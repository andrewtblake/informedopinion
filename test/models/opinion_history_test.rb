require "test_helper"

class OpinionHistoryTest < ActiveSupport::TestCase
  setup do
    @question = OpinionQuestion.create!(
      slug: "history-test",
      title: "History test",
      statement: "This proposition should be accepted.",
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS,
      display_order: 1
    )
    @fact = @question.fact_questions.create!(
      prompt: "Which answer is supported?",
      options: [ "Supported", "Second", "Third", "Fourth" ],
      correct_option: 0,
      explanation: "The first answer is supported.",
      source_name: "Source",
      source_url: "https://example.test/source",
      importance_rationale: "This fact bears directly on the proposition.",
      evidence_direction: 1,
      display_order: 1
    )
    @user = create_user!(
      first_name: "History",
      last_name: "Participant",
      email: "opinion-history@example.test",
      password: "password123"
    )
  end

  test "records the initial response with a knowledge snapshot" do
    opinion = @user.user_opinions.create!(opinion_question: @question, position: 1)
    history = opinion.opinion_histories.sole

    assert history.initial_response?
    assert_nil history.from_position
    assert_equal 1, history.to_position
    assert_equal 0.0, history.knowledge_weight
    assert_equal 0, history.facts_answered
    assert_equal 0, history.facts_correct
    assert_equal 1, history.facts_available
  end

  test "records each changed position and the knowledge state at that moment" do
    opinion = @user.user_opinions.create!(opinion_question: @question, position: 0)
    @user.fact_responses.create!(
      fact_question: @fact,
      selected_option: 0,
      answered_at: Time.current,
      weight_before: 0,
      weight_after: 100
    )

    opinion.update!(position: 3)
    revision = opinion.opinion_histories.revision.sole

    assert_equal 0, revision.from_position
    assert_equal 3, revision.to_position
    assert_equal 100.0, revision.knowledge_weight
    assert_equal 100.0, revision.raw_knowledge_weight
    assert_equal 1, revision.facts_answered
    assert_equal 1, revision.facts_correct
    assert_equal 1, revision.facts_available
  end

  test "does not record an event when an update leaves the position unchanged" do
    opinion = @user.user_opinions.create!(opinion_question: @question, position: 2)

    opinion.update!(position: 2)

    assert_equal 1, opinion.opinion_histories.count
  end

  test "recorded history cannot be edited" do
    opinion = @user.user_opinions.create!(opinion_question: @question, position: 2)
    history = opinion.opinion_histories.sole

    assert_raises(ActiveRecord::ReadOnlyRecord) { history.update!(to_position: 3) }
    assert_equal 2, history.reload.to_position
  end

  test "account deletion removes its opinion history" do
    opinion = @user.user_opinions.create!(opinion_question: @question, position: 2)
    history_id = opinion.opinion_histories.sole.id

    @user.destroy!

    assert_not OpinionHistory.exists?(history_id)
  end
end
