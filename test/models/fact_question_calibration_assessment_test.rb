require "test_helper"

class FactQuestionCalibrationAssessmentTest < ActiveSupport::TestCase
  test "an unfit assessment requires a diagnosis and remediation" do
    assessment = FactQuestionCalibrationAssessment.new(answerability: 0)

    assessment.validate

    assert_includes assessment.errors[:failure_category], "must identify why the question is unfit"
    assert_includes assessment.errors[:remediation], "must propose how to correct or replace the question"
  end

  test "confidence ratings use the five-point scale" do
    assessment = FactQuestionCalibrationAssessment.new(
      specialist_knowledge_confidence: 0,
      answerability_confidence: 6
    )

    assessment.validate

    assert_includes assessment.errors[:specialist_knowledge_confidence], "is not included in the list"
    assert_includes assessment.errors[:answerability_confidence], "is not included in the list"
  end
end
