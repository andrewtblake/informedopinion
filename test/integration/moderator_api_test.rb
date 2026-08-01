require "test_helper"

class ModeratorApiTest < ActionDispatch::IntegrationTest
  setup do
    @moderator = create_user!(email: "api-moderator@example.test", password: "password123", first_name: "API", last_name: "Moderator", role: :moderator)
    @participant = create_user!(email: "proposer@example.test", password: "password123", first_name: "Question", last_name: "Proposer")
    @category = Category.create!(name: "Public policy", slug: "public-policy")
    @token_record, @plaintext = ModeratorApiToken.issue!(user: @moderator, name: "Test agent")
    @headers = { "Authorization" => "Bearer #{@plaintext}", "Content-Type" => "application/json" }
  end

  test "moderator bearer token is required" do
    get api_v1_opinion_questions_path
    assert_response :unauthorized

    participant_token = ModeratorApiToken.new(user: @participant, name: "invalid", token_digest: "x", token_prefix: "x")
    assert_not participant_token.valid?
  end

  test "pending issues omit participant identity and candidate edit does not approve" do
    proposal = OpinionQuestionProposal.create!(proposer: @participant, category: @category, title: "Legalise drugs",
      statement: "Drugs should be legal.", geographic_scope: "United Kingdom", tags_text: "UK, drugs",
      rationale: "The policy merits informed examination.")

    get api_v1_moderation_issues_path, headers: @headers
    assert_response :success
    body = response.parsed_body
    issue = body.fetch("moderation_issues").sole
    assert_equal "opinion_proposal:#{proposal.id}", issue.fetch("id")
    assert_not issue.key?("proposer_id")
    assert_not_includes response.body, @participant.email

    patch api_v1_moderation_issue_path("opinion_proposal:#{proposal.id}"), params: {
      opinion_question_proposal: {
        final_title: "Regulation of currently prohibited drugs",
        final_statement: "The UK should replace criminal prohibition of possession with a regulated legal supply system."
      }
    }.to_json, headers: @headers
    assert_response :success
    assert proposal.reload.pending?
    assert_equal "Regulation of currently prohibited drugs", proposal.final_title
    assert_equal "opinion_proposal.candidate_update", ApiAuditEvent.last.action
  end

  test "bulk fact creation is atomic and audited" do
    opinion = OpinionQuestion.create!(category: @category, title: "A policy", statement: "The UK should adopt the policy.",
      slug: "a-policy", live: false, display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate", response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    valid = fact_payload("What did the measured outcome show?", %w[One Two Three Four])
    invalid = fact_payload("Which estimate is supported?", [ "Same", "Same", "Other", "Last" ])

    post fact_questions_bulk_api_v1_opinion_question_path(opinion), params: { fact_questions: [ valid, invalid ] }.to_json, headers: @headers
    assert_response :unprocessable_entity
    assert_equal 0, opinion.fact_questions.count
    assert_equal 0, ApiAuditEvent.count

    post fact_questions_bulk_api_v1_opinion_question_path(opinion), params: { fact_questions: [ valid ] }.to_json, headers: @headers
    assert_response :created
    assert_equal 1, opinion.fact_questions.count
    assert_equal "fact_question.create", ApiAuditEvent.last.action
  end

  test "plaintext tokens are not stored and revoked tokens stop working" do
    assert_not_equal @plaintext, @token_record.token_digest
    assert_equal ModeratorApiToken.digest(@plaintext), @token_record.token_digest
    @token_record.revoke!

    get api_v1_opinion_questions_path, headers: @headers
    assert_response :unauthorized
  end

  private

  def fact_payload(prompt, options)
    {
      prompt: prompt,
      options: options,
      correct_option: 0,
      explanation: "A concise explanation of the evidence.",
      source_name: "Official statistics",
      source_url: "https://example.test/evidence",
      importance_weight: 2,
      importance_rationale: "This bears directly on the proposition.",
      evidence_direction: 0
    }
  end
end
