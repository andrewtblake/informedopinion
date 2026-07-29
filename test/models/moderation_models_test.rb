require "test_helper"

class ModerationModelsTest < ActiveSupport::TestCase
  test "other fact reports require details" do
    flag = FactQuestionFlag.new(category: :other, details: "")

    assert_not flag.valid?
    assert_includes flag.errors[:details], "can't be blank"
  end

  test "proposal exposes clean unique tag names" do
    proposal = OpinionQuestionProposal.new(tags_text: "Housing, England, Housing,  Planning ")

    assert_equal [ "Housing", "England", "Planning" ], proposal.tag_names
  end
end
