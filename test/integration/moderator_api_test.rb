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

  test "creating an opinion question assigns the next display order despite the database default" do
    existing = OpinionQuestion.create!(
      category: @category,
      title: "Existing question",
      statement: "This question already exists.",
      slug: "existing-question",
      display_order: 7,
      accent: "slate",
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS
    )

    post api_v1_opinion_questions_path, params: {
      opinion_question: {
        title: "New question",
        statement: "This question should be created as an unpublished draft.",
        category_id: @category.id,
        tag_names: [ "Global" ]
      }
    }.to_json, headers: @headers

    assert_response :created
    created = OpinionQuestion.find(response.parsed_body.fetch("id"))
    assert_equal existing.display_order + 1, created.display_order
    assert_not created.live?
    assert_equal [ "Global" ], created.tags.pluck(:name)
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
    assert_equal 3, response.parsed_body.dig("fact_questions", 0, "specialist_knowledge")
    assert_equal 4, response.parsed_body.dig("fact_questions", 0, "answerability")
    assert_match(/\A[0-9a-f]{64}\z/, response.parsed_body.dig("fact_questions", 0, "content_fingerprint"))
    assert_equal "fact_question.create", ApiAuditEvent.last.action
    assert_not opinion.reload.live?
  end

  test "bulk fact creation accepts a bank larger than thirty questions in one request" do
    opinion = OpinionQuestion.create!(category: @category, title: "A larger bank", statement: "The policy should be considered.",
      slug: "a-larger-bank", live: false, display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate", response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    facts = 31.times.map do |index|
      fact_payload("What did measured outcome #{index + 1} show?", %w[One Two Three Four])
    end

    post fact_questions_bulk_api_v1_opinion_question_path(opinion),
      params: { fact_questions: facts }.to_json, headers: @headers

    assert_response :created
    assert_equal 31, opinion.fact_questions.count
    assert_equal 31, response.parsed_body.fetch("fact_questions").length
  end

  test "new API fact questions require assessed passing calibration ratings" do
    opinion = OpinionQuestion.create!(category: @category, title: "Calibration", statement: "The policy should be adopted.",
      slug: "calibration", live: false, display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate", response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    payload = fact_payload("What does the evidence show?", %w[One Two Three Four])

    post fact_questions_bulk_api_v1_opinion_question_path(opinion),
      params: { fact_questions: [ payload.except(:specialist_knowledge) ] }.to_json, headers: @headers
    assert_response :unprocessable_entity

    post fact_questions_bulk_api_v1_opinion_question_path(opinion),
      params: { fact_questions: [ payload.merge(answerability: 0) ] }.to_json, headers: @headers
    assert_response :unprocessable_entity
    assert_empty opinion.fact_questions
  end

  test "fact revision handling preserves responses only with an audited justification" do
    opinion = OpinionQuestion.create!(category: @category, title: "Revision policy", statement: "The policy should be adopted.",
      slug: "revision-policy", live: false, display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate", response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    fact = opinion.fact_questions.create!(fact_payload("According to IFS, what happened?", %w[One Two Three Four]))
    retained = @participant.fact_responses.create!(fact_question: fact, selected_option: 0,
      weight_before: 0, weight_after: 100, answered_at: Time.current)

    patch api_v1_fact_question_path(fact), params: { fact_question: {
      prompt: "According to the Institute for Fiscal Studies, what happened?",
      response_handling: "clarification_preserve",
      revision_rationale: "Expanding the institution name leaves the tested fact and all choices unchanged."
    } }.to_json, headers: @headers

    assert_response :success
    assert_equal retained, fact.fact_responses.reload.sole
    policy = ApiAuditEvent.last.change_data.fetch("revision_policy")
    assert_equal "clarification_preserve", policy.fetch("response_handling")
    assert_match(/institution name/, policy.fetch("rationale"))

    patch api_v1_fact_question_path(fact), params: { fact_question: {
      prompt: "What did the revised analysis find?",
      response_handling: "substantive_reset",
      revision_rationale: "The evidence tested by the prompt has changed."
    } }.to_json, headers: @headers

    assert_response :success
    assert_empty fact.fact_responses.reload
    assert_equal "substantive_reset", ApiAuditEvent.last.change_data.dig("revision_policy", "response_handling")
  end

  test "API rejects score preservation without a rationale" do
    opinion = OpinionQuestion.create!(category: @category, title: "Revision validation", statement: "The policy should be adopted.",
      slug: "revision-validation", live: false, display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate", response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    fact = opinion.fact_questions.create!(fact_payload("Which result was reported?", %w[One Two Three Four]))

    patch api_v1_fact_question_path(fact), params: { fact_question: {
      prompt: "Which result did the report identify?",
      response_handling: "cosmetic_preserve"
    } }.to_json, headers: @headers

    assert_response :unprocessable_entity
    assert response.parsed_body.fetch("details").key?("revision_rationale")
  end

  test "AI calibration submission is complete, fingerprinted, atomic and audited" do
    opinion = OpinionQuestion.create!(category: @category, title: "AI calibration", statement: "The policy should be adopted.",
      slug: "ai-calibration", live: false, display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate", response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    facts = 2.times.map do |index|
      opinion.fact_questions.create!(fact_payload("Calibration fact #{index}?", [ "Correct", "A", "B", "C" ])
        .except(:specialist_knowledge, :answerability).merge(display_order: index + 1))
    end
    assessments = facts.map { calibration_payload(_1) }

    post calibration_assessments_bulk_api_v1_opinion_question_path(opinion), params: {
      assessor_name: "Test AI",
      run_identifier: "test-run-1",
      assessments: assessments
    }.to_json, headers: @headers

    assert_response :created
    assert_equal 2, FactQuestionCalibrationAssessment.count
    assert facts.all? { _1.reload.specialist_knowledge == 3 && _1.answerability == 4 }
    assert FactQuestionCalibrationAssessment.all.all?(&:ai_proposed?)
    assert_equal 2, ApiAuditEvent.where(action: "fact_question_calibration.ai_propose").count

    stale = facts.map { calibration_payload(_1) }
    facts.first.update!(prompt: "Changed after assessment")
    assert_no_difference "FactQuestionCalibrationAssessment.count" do
      post calibration_assessments_bulk_api_v1_opinion_question_path(opinion), params: {
        assessor_name: "Test AI",
        run_identifier: "test-run-2",
        assessments: stale
      }.to_json, headers: @headers
    end
    assert_response :unprocessable_entity
  end

  test "API publication is explicit and requires a complete fact bank" do
    opinion = OpinionQuestion.create!(category: @category, title: "Publication review", statement: "The UK should adopt this measure.",
      slug: "publication-review", live: false, display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate", response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)

    post api_v1_opinion_question_publication_path(opinion), headers: @headers
    assert_response :unprocessable_entity
    assert_not opinion.reload.live?

    10.times do |index|
      attributes = fact_payload("Publication fact #{index}?", [ "Correct #{index}", "Alternative A", "Alternative B", "Alternative C" ])
      opinion.fact_questions.create!(attributes.merge(display_order: index + 1))
    end

    post api_v1_opinion_question_publication_path(opinion), headers: @headers
    assert_response :success
    assert opinion.reload.live?
    assert_equal "opinion_question.publish", ApiAuditEvent.last.action
  end

  test "plaintext tokens are not stored and revoked tokens stop working" do
    assert_not_equal @plaintext, @token_record.token_digest
    assert_equal ModeratorApiToken.digest(@plaintext), @token_record.token_digest
    @token_record.revoke!

    get api_v1_opinion_questions_path, headers: @headers
    assert_response :unauthorized
  end

  test "anonymous dislikes are moderation issues and can be reviewed through the API" do
    opinion = OpinionQuestion.create!(category: @category, title: "Reaction review", statement: "The policy should be adopted.",
      slug: "reaction-review", live: true, display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate", response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    reaction = @participant.opinion_question_reactions.create!(opinion_question: opinion, kind: :dislike,
      reason: "The wording assumes a disputed premise.")

    get api_v1_moderation_issues_path(type: "opinion_reaction"), headers: @headers
    assert_response :success
    issue = response.parsed_body.fetch("moderation_issues").sole
    assert_equal "opinion_reaction:#{reaction.id}", issue.fetch("id")
    assert_equal reaction.reason, issue.fetch("reason")
    assert_not issue.key?("user_id")
    assert_not_includes response.body, @participant.email

    post resolve_api_v1_moderation_issue_path("opinion_reaction:#{reaction.id}"),
      params: { outcome: "reviewed", resolution_notes: "Editorial wording review required." }.to_json,
      headers: @headers
    assert_response :success
    assert reaction.reload.moderation_reviewed?
    assert_equal "opinion_reaction.reviewed", ApiAuditEvent.last.action
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
      evidence_direction: 0,
      specialist_knowledge: 3,
      answerability: 4
    }
  end

  def calibration_payload(fact)
    {
      fact_question_id: fact.id,
      content_fingerprint: FactQuestionCalibrationAudit.fingerprint(fact),
      specialist_knowledge: 3,
      specialist_knowledge_rationale: "The fact requires focused reading about the issue.",
      specialist_knowledge_confidence: 4,
      answerability: 4,
      answerability_rationale: "The choices are accessible but require substantive reading.",
      answerability_confidence: 4
    }
  end
end
