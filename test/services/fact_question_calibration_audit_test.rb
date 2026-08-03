require "test_helper"

class FactQuestionCalibrationAuditTest < ActiveSupport::TestCase
  setup do
    category = Category.create!(name: "Calibration policy", slug: "calibration-policy")
    @opinion = OpinionQuestion.create!(
      category: category,
      title: "Calibration topic",
      statement: "The policy should be adopted.",
      slug: "calibration-topic",
      display_order: 1,
      accent: "slate",
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS
    )
    @fact = @opinion.fact_questions.create!(
      prompt: "What did the official measure show?",
      options: [ "A measured increase", "No measured change", "A measured decrease", "No measurement" ],
      correct_option: 0,
      explanation: "The official measure reported an increase.",
      source_name: "Official source",
      source_url: "https://example.test/calibration",
      importance_weight: 2,
      importance_rationale: "The result bears on the proposition.",
      evidence_direction: 1,
      display_order: 1
    )
  end

  test "worksheet inventories content without inventing assessments" do
    worksheet = FactQuestionCalibrationAudit.new(questions: OpinionQuestion.where(id: @opinion.id)).worksheet
    entry = worksheet.dig("banks", 0, "questions", 0)

    assert_equal @fact.id, entry["id"]
    assert_equal @fact.options, entry["options"]
    assert_nil entry.dig("assessment", "specialist_knowledge")
    assert_nil entry.dig("assessment", "answerability")
    assert_match(/\A[0-9a-f]{64}\z/, entry["content_fingerprint"])
  end

  test "completed worksheets validate and report distributions" do
    worksheet = FactQuestionCalibrationAudit.new(questions: OpinionQuestion.where(id: @opinion.id)).worksheet
    assessment = worksheet.dig("banks", 0, "questions", 0, "assessment")
    assessment.merge!(
      "specialist_knowledge" => 3,
      "specialist_knowledge_reason" => "The result requires focused reading about this policy.",
      "answerability" => 4,
      "answerability_reason" => "The alternatives are credible but the central distinction is accessible."
    )

    assert FactQuestionCalibrationAudit.validate!(worksheet, questions: OpinionQuestion.where(id: @opinion.id))
    report = FactQuestionCalibrationAudit.report(worksheet).dig("banks", 0)
    assert_equal 1, report.dig("specialist_knowledge", "3")
    assert_equal 1, report.dig("answerability", "4")
    assert_equal({ "3:4" => 1 }, report["cross_tabulation"])
    assert_empty report["unrated_question_ids"]
    assert_empty report["unfit_question_ids"]
  end

  test "unfit assessments require a diagnosis and remediation" do
    worksheet = FactQuestionCalibrationAudit.new(questions: OpinionQuestion.where(id: @opinion.id)).worksheet
    assessment = worksheet.dig("banks", 0, "questions", 0, "assessment")
    assessment.merge!(
      "specialist_knowledge" => 2,
      "specialist_knowledge_reason" => "The subject is commonly covered in current affairs.",
      "answerability" => 0,
      "answerability_reason" => "Three choices are conspicuously absurd."
    )

    error = assert_raises(FactQuestionCalibrationAudit::InvalidWorksheet) do
      FactQuestionCalibrationAudit.validate!(worksheet, questions: OpinionQuestion.where(id: @opinion.id))
    end
    assert_includes error.message, "recognised failure category"
    assert_includes error.message, "remediation proposal"

    assessment.merge!(
      "failure_category" => "implausible_distractors",
      "remediation" => "Replace the distractors with credible alternative findings."
    )
    assert FactQuestionCalibrationAudit.validate!(worksheet, questions: OpinionQuestion.where(id: @opinion.id))
  end

  test "validation detects content changed after export" do
    worksheet = completed_worksheet
    @fact.update!(prompt: "What did the revised official measure show?")

    error = assert_raises(FactQuestionCalibrationAudit::InvalidWorksheet) do
      FactQuestionCalibrationAudit.validate!(worksheet, questions: OpinionQuestion.where(id: @opinion.id))
    end
    assert_includes error.message, "changed after export"
  end

  private

  def completed_worksheet
    FactQuestionCalibrationAudit.new(questions: OpinionQuestion.where(id: @opinion.id)).worksheet.tap do |worksheet|
      worksheet.dig("banks", 0, "questions", 0, "assessment").merge!(
        "specialist_knowledge" => 3,
        "specialist_knowledge_reason" => "The fact requires focused policy reading.",
        "answerability" => 3,
        "answerability_reason" => "Several alternatives are initially credible."
      )
    end
  end
end
