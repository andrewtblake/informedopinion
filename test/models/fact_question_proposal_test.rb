require "test_helper"

class FactQuestionProposalTest < ActiveSupport::TestCase
  test "source links must be complete HTTP or HTTPS URLs" do
    proposal = FactQuestionProposal.new(source_url: "javascript:alert(1)")

    proposal.validate

    assert_includes proposal.errors[:source_url], "is invalid"
  end

  test "all four proposed answers must be present and distinct" do
    proposal = FactQuestionProposal.new(options: [ "Same", "Same", "", "Different" ])

    proposal.validate

    assert_includes proposal.errors[:options], "must all be present"
    assert_includes proposal.errors[:options], "must be distinct"
  end

  test "calibration ratings use the fact-question scales" do
    proposal = FactQuestionProposal.new(specialist_knowledge: 0, answerability: -1)

    proposal.validate

    assert_includes proposal.errors[:specialist_knowledge], "is not included in the list"
    assert_includes proposal.errors[:answerability], "is not included in the list"
  end
end
