require "test_helper"

class GlossaryApiTest < ActionDispatch::IntegrationTest
  setup do
    @moderator = create_user!(first_name: "Glossary", last_name: "Moderator",
      email: "glossary-moderator@example.test", password: "password123", role: :moderator)
    @token, secret = ModeratorApiToken.issue!(user: @moderator, name: "Glossary editor")
    @headers = { "Authorization" => "Bearer #{secret}" }
    @entry = GlossaryEntry.find_by!(term: "UNRWA")
  end

  test "all glossary endpoints require a moderator token including reads" do
    get api_v1_glossary_entries_path
    assert_response :unauthorized
    get api_v1_glossary_entry_path(@entry)
    assert_response :unauthorized
    post api_v1_glossary_entries_path, params: { glossary_entry: { term: "TEST", definition: "Example" } }
    assert_response :unauthorized
    patch api_v1_glossary_entry_path(@entry), params: { glossary_entry: { definition: "Changed" } }
    assert_response :unauthorized
    delete api_v1_glossary_entry_path(@entry)
    assert_response :unauthorized
    assert @entry.reload.persisted?
  end

  test "search and read expose the imported definitions without writes" do
    assert_no_difference "ApiAuditEvent.count" do
      get api_v1_glossary_entries_path, params: { q: "UNRWA" }, headers: @headers
      assert_response :success
      assert_equal [ "UNRWA" ], response.parsed_body.fetch("glossary_entries").map { _1.fetch("term") }
      get api_v1_glossary_entry_path(@entry), headers: @headers
      assert_equal @entry.definition, response.parsed_body.fetch("definition")
    end
  end

  test "create update and delete are audited with the acting token" do
    assert_difference [ "GlossaryEntry.count", "ApiAuditEvent.count" ], 1 do
      post api_v1_glossary_entries_path, params: { glossary_entry: { term: "TEST", definition: "A test definition" } },
        headers: @headers, as: :json
      assert_response :created
    end
    record = GlossaryEntry.find(response.parsed_body.fetch("id"))
    assert_equal "glossary_entry.create", ApiAuditEvent.last.action
    assert_equal @token.id, ApiAuditEvent.last.moderator_api_token_id
    assert_equal @moderator.id, ApiAuditEvent.last.actor_id

    assert_difference "ApiAuditEvent.count", 1 do
      patch api_v1_glossary_entry_path(record), params: { glossary_entry: { definition: "Revised definition" } },
        headers: @headers, as: :json
      assert_response :success
    end
    assert_equal "Revised definition", record.reload.definition
    assert_equal [ "A test definition", "Revised definition" ], ApiAuditEvent.last.change_data.fetch("definition")

    assert_difference "GlossaryEntry.count", -1 do
      assert_difference "ApiAuditEvent.count", 1 do
        delete api_v1_glossary_entry_path(record), headers: @headers
        assert_response :no_content
      end
    end
    assert_equal "glossary_entry.destroy", ApiAuditEvent.last.action
    assert_equal record.id, ApiAuditEvent.last.resource_id
  end

  test "invalid and duplicate terms neither save nor create audit events" do
    [ { term: "UNRWA", definition: "Duplicate" }, { term: "BAD TERM", definition: "Invalid" },
      { term: "TEST", definition: "" } ].each do |attributes|
      assert_no_difference [ "GlossaryEntry.count", "ApiAuditEvent.count" ] do
        post api_v1_glossary_entries_path, params: { glossary_entry: attributes }, headers: @headers, as: :json
        assert_response :unprocessable_entity
      end
    end
  end

  test "new definitions edits and removals appear on the next page request" do
    opinion = OpinionQuestion.create!(title: "Glossary example", statement: "A statement.", slug: "glossary-example",
      display_order: 1, accent: "slate", live: false, response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    opinion.fact_questions.create!(prompt: "What is TEST?", options: [ "One", "Two", "Three", "Four" ],
      correct_option: 0, explanation: "TEST evidence.", source_name: "Example", source_url: "https://example.org/",
      importance_weight: 1, importance_rationale: "Example.", evidence_direction: 0,
      specialist_knowledge: 1, answerability: 4)
    sign_in @moderator
    get moderator_opinion_question_fact_bank_path(opinion)
    assert_select "abbr", text: "TEST", count: 0

    post api_v1_glossary_entries_path, params: { glossary_entry: { term: "TEST", definition: "First definition" } },
      headers: @headers, as: :json
    assert_response :created
    record = GlossaryEntry.find(response.parsed_body.fetch("id"))
    get moderator_opinion_question_fact_bank_path(opinion)
    assert_select "abbr[title='First definition'][tabindex='0']", text: "TEST", minimum: 1

    patch api_v1_glossary_entry_path(record), params: { glossary_entry: { definition: "Second definition" } },
      headers: @headers, as: :json
    get moderator_opinion_question_fact_bank_path(opinion)
    assert_select "abbr[title='Second definition']", text: "TEST", minimum: 1
    assert_select "abbr[title='First definition']", count: 0

    delete api_v1_glossary_entry_path(record), headers: @headers
    get moderator_opinion_question_fact_bank_path(opinion)
    assert_select "abbr", text: "TEST", count: 0
    assert_includes response.body, "What is TEST?"
  end
end
