require "test_helper"

class FactQuestionProposalWorkflowTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create!(name: "Evidence policy", slug: "evidence-policy")
    @topic = OpinionQuestion.create!(
      slug: "fact-contribution-topic",
      title: "Fact contribution topic",
      statement: "The specified policy should be adopted.",
      category: @category,
      response_options: [ "Strongly agree", "Somewhat agree", "Neutral", "Somewhat disagree", "Strongly disagree" ],
      display_order: 1,
      accent: "slate"
    )
    @participant = create_user("qualified@example.com")
    @moderator = create_user("fact-moderator@example.com", role: :moderator)
  end

  test "eligibility requires the configured number of existing questions" do
    create_facts(9)
    answer_all(correct_count: 9)
    sign_in @participant, scope: :user

    get opinion_question_path(@topic)

    assert_response :success
    assert_select ".fact-contribution-panel", text: /at least 10 published fact questions/
    assert_select "a", text: "Propose a fact question", count: 0

    get new_opinion_question_fact_question_proposal_path(@topic)
    assert_redirected_to opinion_question_path(@topic)
  end

  test "eligibility requires every answer and a configured 90 percent score" do
    create_facts(10)
    answer_all(correct_count: 8)
    sign_in @participant, scope: :user

    get opinion_question_path(@topic)
    assert_select ".fact-contribution-panel", text: /at least 90%.*current score is 80%/m

    @participant.fact_responses.last.update!(selected_option: 0)
    get opinion_question_path(@topic)
    assert_select ".fact-contribution-panel", text: /eligible to propose/
    assert_select "a", text: "Propose a fact question", count: 1

    @participant.fact_responses.last.update!(selected_option: 1)
    @participant.fact_responses.first.destroy!
    get opinion_question_path(@topic)
    assert_select ".fact-contribution-panel", text: /Answer all 10 published fact questions/
  end

  test "a qualified participant can submit a complete fact question" do
    create_facts(10)
    answer_all(correct_count: 9)
    sign_in @participant, scope: :user

    get new_opinion_question_fact_question_proposal_path(@topic)
    assert_response :success
    assert_select "h1", "Propose a fact question"
    assert_select ".fact-proposition-reference", text: /The specified policy should be adopted/
    assert_select "input[name='fact_question_proposal[options][]']", count: 4
    assert_select "input[name='fact_question_proposal[correct_option]']", count: 4

    assert_difference "FactQuestionProposal.count", 1 do
      post opinion_question_fact_question_proposals_path(@topic), params: {
        fact_question_proposal: proposal_attributes
      }
    end

    assert_redirected_to opinion_question_path(@topic)
    proposal = FactQuestionProposal.last
    assert_equal @participant, proposal.proposer
    assert_equal @topic, proposal.opinion_question
    assert proposal.pending?
  end

  test "the server rejects a direct submission from an ineligible participant" do
    create_facts(10)
    answer_all(correct_count: 8)
    sign_in @participant, scope: :user

    assert_no_difference "FactQuestionProposal.count" do
      post opinion_question_fact_question_proposals_path(@topic), params: {
        fact_question_proposal: proposal_attributes
      }
    end

    assert_redirected_to opinion_question_path(@topic)
  end

  test "a moderator anonymously edits and publishes a proposed fact" do
    create_facts(10)
    proposal = @participant.fact_question_proposals.create!(
      proposal_attributes.merge(opinion_question: @topic)
    )
    sign_in @moderator, scope: :user

    get moderator_root_path
    assert_response :success
    assert_select ".fact-moderation-editor"
    assert_not_includes response.body, @participant.email

    assert_difference "FactQuestion.count", 1 do
      patch moderator_fact_question_proposal_path(proposal), params: {
        fact_question_proposal: proposal_attributes.merge(
          status: "approved",
          prompt: "What does the revised primary source establish?",
          review_notes: "Internal note."
        )
      }
    end

    proposal.reload
    assert proposal.approved?
    assert_equal @moderator, proposal.reviewer
    assert_equal "What does the revised primary source establish?", proposal.published_fact_question.prompt
    assert_equal 11, proposal.published_fact_question.display_order
  end

  private

  def create_facts(count)
    count.times do |index|
      @topic.fact_questions.create!(
        prompt: "Published fact #{index + 1}?",
        options: [ "Correct", "Plausible A", "Plausible B", "Plausible C" ],
        correct_option: 0,
        explanation: "The source supports the correct answer.",
        source_name: "Primary source",
        source_url: "https://example.com/fact-#{index + 1}",
        importance_weight: 1,
        importance_rationale: "Supporting context.",
        evidence_direction: 0,
        display_order: index + 1
      )
    end
  end

  def answer_all(correct_count:)
    @topic.fact_questions.each_with_index do |fact, index|
      @participant.fact_responses.create!(
        fact_question: fact,
        selected_option: index < correct_count ? 0 : 1,
        answered_at: Time.current,
        weight_before: 0,
        weight_after: 0
      )
    end
  end

  def proposal_attributes
    {
      prompt: "What does the primary source establish?",
      options: [ "Finding A", "Finding B", "Finding C", "Finding D" ],
      correct_option: 1,
      explanation: "The source reports Finding B.",
      source_name: "Primary source",
      source_url: "https://example.com/proposed-fact",
      importance_weight: 2,
      importance_rationale: "The finding bears directly on a central premise.",
      evidence_direction: -1
    }
  end

  def create_user(email, role: :participant)
    create_user!(
      first_name: role.to_s.humanize,
      last_name: "User",
      email: email,
      password: "password123",
      role: role
    )
  end
end
