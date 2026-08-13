require "test_helper"

class FactQuestionTest < ActiveSupport::TestCase
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
end
