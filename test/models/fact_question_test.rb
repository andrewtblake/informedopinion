require "test_helper"

class FactQuestionTest < ActiveSupport::TestCase
  test "correct option must point to an available answer" do
    question = FactQuestion.new(
      options: [ "One", "Two" ],
      correct_option: 2
    )

    question.validate

    assert_includes question.errors[:correct_option],
      "must identify one of the available options"
  end
end
