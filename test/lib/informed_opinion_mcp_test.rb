require "test_helper"
require "informed_opinion_mcp"

class InformedOpinionMcpTest < ActiveSupport::TestCase
  test "server exposes focused tools and editorial resources" do
    server = InformedOpinionMcp.server
    tool_names = server.tools.keys

    assert_includes tool_names, "list_moderation_issues"
    assert_includes tool_names, "save_opinion_proposal_edit"
    assert_includes tool_names, "decide_moderation_issue"
    assert_includes tool_names, "create_fact_questions"
    assert_includes tool_names, "publish_opinion_question"
    assert_includes tool_names, "submit_fact_question_calibrations"
    assert_includes server.resources.map(&:uri), "informed-opinion://editorial-standard"
  end


  test "fact creation schema requires both calibration ratings" do
    schema = InformedOpinionMcp.server.tools.fetch("create_fact_questions").input_schema
      .instance_variable_get(:@schema)
    required = schema.dig(:properties, :fact_questions, :items, :required)

    assert_includes required, "specialist_knowledge"
    assert_includes required, "answerability"
    assert_equal 100, schema.dig(:properties, :fact_questions, :maxItems)
  end

  test "tool handlers accept keyword arguments from the MCP server" do
    received = nil
    server = MCP::Server.new(name: "test", version: "1")
    InformedOpinionMcp.send(:tool, server, "example", "Example", {}) do |args|
      received = args
      { "ok" => true }
    end

    response = server.tools.fetch("example").call(status: "pending", server_context: nil)

    assert_instance_of MCP::Tool::Response, response
    assert_equal({ status: "pending" }, received)
  end
end
