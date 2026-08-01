require "test_helper"
require Rails.root.join("db/migrate/20260731212500_reconcile_approved_opinion_question_drafts")

class OpinionQuestionLifecycleTest < ActionDispatch::IntegrationTest
  setup do
    @category = Category.create!(name: "Lifecycle policy", slug: "lifecycle-policy")
    @participant = create_user("lifecycle-participant@example.com")
    @moderator = create_user("lifecycle-moderator@example.com", role: :moderator)
  end

  test "an approved opinion proposal remains an editorial draft without facts" do
    proposal = @participant.opinion_question_proposals.create!(
      title: "Draft public question",
      statement: "The defined public policy should be adopted.",
      category: @category,
      tags_text: "Public policy, United Kingdom",
      rationale: "The proposition is contested and factually assessable."
    )
    sign_in @moderator, scope: :user

    patch moderator_opinion_question_proposal_path(proposal), params: {
      opinion_question_proposal: {
        status: "approved",
        final_title: proposal.title,
        final_statement: proposal.statement
      }
    }

    draft = proposal.reload.published_opinion_question
    assert_not draft.live?

    sign_out @moderator
    sign_in @participant, scope: :user
    get opinion_question_proposals_path
    assert_select ".proposal-status", text: /Approved — being prepared/

    sign_out @participant
    sign_in @moderator, scope: :user
    get moderator_root_path
    assert_select ".draft-question-item", text: /Draft public question.*0.*published fact questions.*10 required/m
    assert_select ".draft-question-item a", text: "Add fact question"

    sign_out @moderator
    sign_in @participant, scope: :user
    get root_path
    assert_not_includes response.body, "Draft public question"
    get opinion_question_path(draft)
    assert_response :not_found
  end

  test "an empty knowledge quiz redirects instead of raising an error" do
    question = create_question(live: true)
    @participant.user_opinions.create!(opinion_question: question, position: 2)
    sign_in @participant, scope: :user

    get opinion_question_quiz_path(question)

    assert_redirected_to opinion_question_path(question)
    follow_redirect!
    assert_response :success
    assert_select ".flash-alert", text: /not available until fact questions have been added/
  end

  test "a moderator reviews a complete fact bank and explicitly makes the question live" do
    question = create_question(live: false)
    sign_in @moderator, scope: :user

    get new_opinion_question_fact_question_proposal_path(question)
    assert_response :success
    assert_select ".fact-proposition-reference", text: /The lifecycle policy should be adopted/

    10.times do |index|
      assert_difference [ "FactQuestion.count", "FactQuestionProposal.count" ], 1 do
        post opinion_question_fact_question_proposals_path(question), params: {
          fact_question_proposal: fact_attributes(index)
        }
      end
      assert_redirected_to opinion_question_path(question)
      assert FactQuestionProposal.order(:id).last.approved?
      assert_not question.reload.live?
    end

    assert_not question.reload.live?
    assert_equal 10, question.fact_questions.count
    get moderator_root_path
    assert_select ".draft-question-item", text: /Lifecycle question.*10.*published fact questions/m
    assert_select ".fact-bank-review > ol > li", count: 10
    assert_select "form[action='#{moderator_opinion_question_publication_path(question)}']"

    post moderator_opinion_question_publication_path(question)
    assert_redirected_to moderator_root_path(anchor: "question-preparation")
    assert question.reload.live?

    get root_path
    assert_includes response.body, question.title
  end

  test "a moderator cannot publish a draft before the minimum is reached" do
    question = create_question(live: false)
    sign_in @moderator, scope: :user

    post moderator_opinion_question_publication_path(question)

    assert_redirected_to moderator_root_path(anchor: "question-preparation")
    assert_not question.reload.live?
    follow_redirect!
    assert_select ".flash-alert", text: /requires at least 10 published fact questions/
  end

  test "legacy approved proposals and empty live questions are reconciled as drafts" do
    accidental_live_question = create_question(live: true)
    legacy_proposal = @participant.opinion_question_proposals.create!(
      title: "Legacy Moon proposal",
      statement: "Humans landed on the Moon.",
      category: @category,
      tags_text: "Moon, Space",
      rationale: "The claim can be assessed using physical evidence.",
      status: :approved,
      reviewer: @moderator,
      reviewed_at: Time.current
    )

    ReconcileApprovedOpinionQuestionDrafts.new.up

    assert_not accidental_live_question.reload.live?
    published = legacy_proposal.reload.published_opinion_question
    assert_not_nil published
    assert_not published.live?
    assert_equal [ "Moon", "Space" ], published.tags.order(:name).pluck(:name)
  end

  private

  def create_question(live:)
    OpinionQuestion.create!(
      slug: "lifecycle-question-#{OpinionQuestion.maximum(:id).to_i + 1}",
      title: "Lifecycle question",
      statement: "The lifecycle policy should be adopted.",
      category: @category,
      response_options: [ "Strongly agree", "Somewhat agree", "Neutral", "Somewhat disagree", "Strongly disagree" ],
      display_order: OpinionQuestion.maximum(:display_order).to_i + 1,
      accent: "slate",
      live: live
    )
  end

  def fact_attributes(index)
    {
      prompt: "Lifecycle fact #{index + 1}?",
      options: [ "Correct #{index}", "Plausible A", "Plausible B", "Plausible C" ],
      correct_option: 0,
      explanation: "The source supports the marked answer.",
      source_name: "Primary source",
      source_url: "https://example.com/lifecycle-#{index + 1}",
      importance_weight: 1,
      importance_rationale: "Relevant supporting context.",
      evidence_direction: 0
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
