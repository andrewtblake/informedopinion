require "json"
require "net/http"
require "uri"
require "mcp"

module InformedOpinionMcp
  class ApiClient
    def initialize
      @base_url = ENV.fetch("INFORMED_OPINION_API_URL", "http://localhost:3000/api/v1").sub(%r{/+\z}, "")
    end

    def request(method, path, body = nil)
      token = ENV.fetch("INFORMED_OPINION_API_TOKEN") do
        raise "INFORMED_OPINION_API_TOKEN is not available to the MCP process. Export it before starting Codex or configure it with `codex mcp add --env`."
      end
      uri = URI("#{@base_url}/#{path.sub(%r{\A/+}, '')}")
      request = Net::HTTP.const_get(method.capitalize).new(uri)
      request["Authorization"] = "Bearer #{token}"
      request["Accept"] = "application/json"
      if body
        request["Content-Type"] = "application/json"
        request.body = JSON.generate(body)
      end
      response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == "https") { _1.request(request) }
      parsed = response.body.to_s.empty? ? {} : JSON.parse(response.body)
      raise "API returned #{response.code}: #{parsed}" unless response.is_a?(Net::HTTPSuccess)

      parsed
    end
  end

  class << self
    def server
      client = ApiClient.new
      server = MCP::Server.new(name: "informed_opinion_moderation", version: "1.0.0",
        instructions: "Read the editorial-standard resource before editorial work. Treat reads and drafts as distinct from writes. Never save, approve, decline, resolve, create, update, withdraw, or delete unless the moderator explicitly asks you to apply that action.")
      define_tools(server, client)
      define_resources(server)
      server
    end

    private

    def define_tools(server, client)
      tool(server, "list_moderation_issues", "List issues needing moderator attention. Returns anonymous editorial records.",
        { status: { type: "string", enum: %w[pending approved declined resolved dismissed all], default: "pending" },
          type: { type: "string", enum: %w[fact_report opinion_proposal fact_proposal] } }, read_only: true) do |args|
        query = URI.encode_www_form(args.compact)
        client.request("get", "moderation_issues?#{query}")
      end
      tool(server, "get_moderation_issue", "Read one moderation issue before proposing or applying a decision.",
        { id: { type: "string", description: "Composite ID returned by list_moderation_issues, e.g. opinion_proposal:12" } }, required: %w[id], read_only: true) do |args|
        client.request("get", "moderation_issues/#{args[:id]}")
      end
      tool(server, "save_opinion_proposal_edit", "Save candidate wording on a pending opinion proposal without approving it.",
        { id: { type: "string" }, final_title: { type: "string" }, final_statement: { type: "string" } }, required: %w[id final_title final_statement]) do |args|
        id = args.delete(:id)
        client.request("patch", "moderation_issues/#{id}", opinion_question_proposal: args)
      end
      tool(server, "decide_moderation_issue", "Explicitly approve or decline a proposal, or resolve a fact report. This changes moderation state.",
        { id: { type: "string" }, action: { type: "string", enum: %w[approve decline resolve] }, review_notes: { type: "string" },
          outcome: { type: "string", enum: %w[corrected withdrawn dismissed] }, fact_question: { type: "object" } }, required: %w[id action]) do |args|
        action = args.delete(:action)
        client.request("post", "moderation_issues/#{args.delete(:id)}/#{action}", args)
      end
      tool(server, "list_opinion_questions", "Search all opinion questions, including unpublished questions being prepared.",
        { q: { type: "string" }, live: { type: "boolean" } }, read_only: true) do |args|
        client.request("get", "opinion_questions?#{URI.encode_www_form(args.compact)}")
      end
      tool(server, "get_opinion_question", "Read an opinion question and its complete fact bank.",
        { id: { type: "integer" } }, required: %w[id], read_only: true) { |args| client.request("get", "opinion_questions/#{args[:id]}") }
      tool(server, "create_opinion_question", "Create an unpublished opinion question. Prefer approving a user proposal where one exists.",
        { opinion_question: { type: "object" } }, required: %w[opinion_question]) { |args| client.request("post", "opinion_questions", args) }
      tool(server, "update_opinion_question", "Edit an existing opinion question.",
        { id: { type: "integer" }, opinion_question: { type: "object" } }, required: %w[id opinion_question]) do |args|
        client.request("patch", "opinion_questions/#{args.delete(:id)}", args)
      end
      tool(server, "create_fact_questions", "Atomically create 1–30 calibrated, completely self-contained four-option fact questions. No item may refer or allude to another item in the bank or assume a presentation order.",
        { opinion_question_id: { type: "integer" }, fact_questions: { type: "array", minItems: 1, maxItems: 30, items: fact_schema } },
        required: %w[opinion_question_id fact_questions]) do |args|
        client.request("post", "opinion_questions/#{args.delete(:opinion_question_id)}/fact_questions/bulk", args)
      end
      tool(server, "publish_opinion_question", "Mark an eligible opinion question as live after the moderator has reviewed and accepted its complete fact bank.",
        { opinion_question_id: { type: "integer" } }, required: %w[opinion_question_id]) do |args|
        client.request("post", "opinion_questions/#{args[:opinion_question_id]}/publication")
      end
      tool(server, "unpublish_opinion_question", "Take an opinion question out of public view without deleting its editorial or participation history.",
        { opinion_question_id: { type: "integer" } }, required: %w[opinion_question_id]) do |args|
        client.request("delete", "opinion_questions/#{args[:opinion_question_id]}/publication")
      end
      tool(server, "update_fact_question", "Correct, recalibrate, or withdraw a fact question.",
        { id: { type: "integer" }, fact_question: { type: "object" } }, required: %w[id fact_question]) do |args|
        client.request("patch", "fact_questions/#{args.delete(:id)}", args)
      end
    end

    def tool(server, name, description, properties, required: [], read_only: false, &block)
      server.define_tool(name: name, description: description,
        input_schema: { type: "object", properties: properties, required: required },
        annotations: { read_only_hint: read_only }) do |args, server_context:|
        result = block.call(args)
        MCP::Tool::Response.new([ { type: "text", text: JSON.pretty_generate(result) } ])
      rescue StandardError => error
        MCP::Tool::Response.new([ { type: "text", text: error.message } ], error: true)
      end
    end

    def fact_schema
      { type: "object", required: %w[prompt options correct_option explanation source_name source_url importance_weight importance_rationale evidence_direction],
        properties: { prompt: { type: "string", description: "Self-contained wording that does not refer to any other current or planned fact question." }, options: { type: "array", minItems: 4, maxItems: 4, items: { type: "string" } },
          correct_option: { type: "integer", minimum: 0, maximum: 3 }, explanation: { type: "string" }, source_name: { type: "string" },
          source_url: { type: "string" }, importance_weight: { type: "integer", minimum: 1, maximum: 3 },
          importance_rationale: { type: "string" }, evidence_direction: { type: "integer", minimum: -1, maximum: 1 } } }
    end

    def define_resources(server)
      root = File.expand_path("..", __dir__)
      { "informed-opinion://editorial-standard" => [ "editorial-standard", "Editorial standard", File.join(root, "docs/editorial-standard.md") ],
        "informed-opinion://api-guide" => [ "api-guide", "Moderator API and MCP guide", File.join(root, "docs/moderator-api-and-mcp.md") ] }.each do |uri, (name, title, path)|
        server.define_resource(uri: uri, name: name, title: title, mime_type: "text/markdown") do
          [ MCP::Resource::TextContents.new(uri: uri, mime_type: "text/markdown", text: File.read(path)) ]
        end
      end
    end
  end
end
