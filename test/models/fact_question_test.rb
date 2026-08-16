require "test_helper"

class FactQuestionTest < ActiveSupport::TestCase
  test "a justified non-material clarification preserves existing responses" do
    question, response = question_with_response
    question.response_handling = "clarification_preserve"
    question.revision_rationale = "The expanded institution name does not change the tested fact or any choice."

    question.update!(prompt: "According to the Example Institute, which answer is correct?")

    assert_equal response, question.fact_responses.reload.sole
  end

  test "a substantive wording revision resets existing responses" do
    question, = question_with_response

    question.update!(prompt: "Which revised claim is supported?")

    assert_empty question.fact_responses.reload
  end

  test "response preservation requires a rationale and an unchanged answer key" do
    question, = question_with_response
    question.response_handling = "cosmetic_preserve"

    assert_not question.update(prompt: "Which answer is supported?")
    assert_includes question.errors[:revision_rationale], "must explain why existing responses remain valid"

    question.revision_rationale = "Typographical correction only."
    assert_not question.update(correct_option: 1)
    assert_includes question.errors[:response_handling], "cannot preserve responses when the correct option changes"
  end

  test "changing only the answer key recalculates existing responses" do
    category = Category.create!(name: "Answer correction", slug: "answer-correction")
    opinion = OpinionQuestion.create!(
      category: category,
      slug: "answer-correction",
      title: "Answer correction",
      statement: "This answer should be corrected.",
      response_options: [ "Strongly agree", "Agree", "Neutral", "Disagree", "Strongly disagree" ]
    )
    question = opinion.fact_questions.create!(
      prompt: "Which answer is correct?",
      options: [ "Actually correct", "Wrong", "Incorrectly keyed", "Also wrong" ],
      correct_option: 2,
      explanation: "The first answer is correct.",
      source_name: "Source",
      source_url: "https://example.com/source"
    )
    user = create_user!(
      email: "answer-correction@example.com",
      password: "password123",
      first_name: "Answer",
      last_name: "Correction"
    )
    response = user.fact_responses.create!(
      fact_question: question,
      selected_option: 0,
      attempt_count: 1,
      weight_before: 0,
      weight_after: 0,
      answered_at: Time.current
    )
    refute response.correct?

    question.update!(correct_option: 0)

    assert response.reload.correct?
  end

  test "correct option must point to an available answer" do
    question = FactQuestion.new(
      options: [ "One", "Two", "Three", "Four" ],
      correct_option: 4
    )

    question.validate

    assert_includes question.errors[:correct_option],
      "must identify one of the available options"
  end

  test "importance is constrained to the published three-level scale" do
    question = FactQuestion.new(importance_weight: 4)

    question.validate

    assert_includes question.errors[:importance_weight], "is not included in the list"
    assert_equal "Supporting", FactQuestion.new(importance_weight: 1).importance_label
    assert_equal "Foundational", FactQuestion.new(importance_weight: 3).importance_label
  end

  test "published sources and answer choices remain safe and usable" do
    question = FactQuestion.new(
      source_url: "javascript:alert(1)",
      options: [ "Same", "Same", "", "Different" ],
      correct_option: 0
    )

    question.validate

    assert_includes question.errors[:source_url], "is invalid"
    assert_includes question.errors[:options], "must all be present"
    assert_includes question.errors[:options], "must be distinct"
  end

  test "calibration ratings use independent published scales and may remain unassessed" do
    question = FactQuestion.new(specialist_knowledge: 7, answerability: 6)

    question.validate

    assert_includes question.errors[:specialist_knowledge], "is not included in the list"
    assert_includes question.errors[:answerability], "is not included in the list"
    unassessed = FactQuestion.new(specialist_knowledge: nil, answerability: nil).tap(&:validate)
    assert_empty unassessed.errors[:specialist_knowledge]
    assert_empty unassessed.errors[:answerability]
    assert_equal "Sustained study", FactQuestion.new(specialist_knowledge: 4).specialist_knowledge_label
    assert_equal "Unfit", FactQuestion.new(answerability: 0).answerability_label
  end

  private

  def question_with_response
    opinion = OpinionQuestion.create!(
      slug: "revision-#{SecureRandom.hex(3)}",
      title: "Revision handling",
      statement: "This revision should be audited.",
      response_options: [ "A", "B", "C", "D", "E" ]
    )
    question = opinion.fact_questions.create!(
      prompt: "According to the Institute, which answer is correct?",
      options: [ "Correct", "Wrong", "Unsupported", "Unknown" ],
      correct_option: 0,
      explanation: "The first answer is correct.",
      source_name: "Source",
      source_url: "https://example.com/revision"
    )
    user = create_user!(
      email: "revision-#{SecureRandom.hex(3)}@example.com",
      password: "password123",
      first_name: "Revision",
      last_name: "Tester"
    )
    response = user.fact_responses.create!(
      fact_question: question,
      selected_option: 0,
      weight_before: 0,
      weight_after: 100,
      answered_at: Time.current
    )
    [ question, response ]
  end
end
