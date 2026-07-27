require "test_helper"

class FactQuestionTest < ActiveSupport::TestCase
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
end
