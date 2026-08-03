require "test_helper"

class CalibrationSupervisionTest < ActionDispatch::IntegrationTest
  setup do
    category = Category.create!(name: "Calibration supervision", slug: "calibration-supervision")
    @opinion = OpinionQuestion.create!(
      category: category,
      title: "Supervised calibration",
      statement: "The supervised policy should be adopted.",
      slug: "supervised-calibration",
      display_order: 1,
      accent: "slate",
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS
    )
    @fact = @opinion.fact_questions.create!(
      prompt: "What did the official evidence show?",
      options: [ "An increase", "No change", "A decrease", "No measurement" ],
      correct_option: 0,
      explanation: "The official evidence reported an increase.",
      source_name: "Official evidence",
      source_url: "https://example.test/supervision",
      importance_weight: 2,
      importance_rationale: "The result bears directly on the proposition.",
      evidence_direction: 1,
      specialist_knowledge: 3,
      answerability: 4,
      display_order: 1
    )
    @moderator = create_user!(email: "calibration-moderator@example.test", password: "password123",
      first_name: "Calibration", last_name: "Moderator", role: :moderator)
    @assessment = create_assessment
    sign_in @moderator, scope: :user
  end

  test "moderator can inspect the supervisory sample and AI rationale" do
    get moderator_calibration_reviews_path
    assert_response :success
    assert_select ".calibration-bank", text: /Supervised calibration.*1\/1.*Review calibration/m

    get moderator_calibration_review_path(@opinion)
    assert_response :success
    assert_select ".calibration-assessment", count: 1
    assert_select ".calibration-ai-assessment", text: /focused policy reading.*credible alternatives/m
    assert_select "form[action='#{moderator_calibration_assessment_path(@assessment)}']"
  end

  test "moderator can accept an assessment" do
    patch moderator_calibration_assessment_path(@assessment), params: {
      fact_question_calibration_assessment: { decision: "accept", review_notes: "Sample checked." }
    }

    assert_redirected_to moderator_calibration_review_path(@opinion, scope: "sample")
    assert @assessment.reload.accepted?
    assert_equal 3, @assessment.reviewed_specialist_knowledge
    assert_equal 4, @assessment.reviewed_answerability
    assert_equal "fact_question_calibration.accept", ApiAuditEvent.last.action
  end

  test "moderator override changes operational ratings but preserves AI ratings" do
    patch moderator_calibration_assessment_path(@assessment), params: {
      fact_question_calibration_assessment: {
        decision: "override",
        reviewed_specialist_knowledge: 2,
        reviewed_answerability: 3,
        review_notes: "Mainstream coverage makes the fact less specialised."
      }
    }

    assert @assessment.reload.overridden?
    assert_equal 3, @assessment.specialist_knowledge
    assert_equal 4, @assessment.answerability
    assert_equal 2, @assessment.reviewed_specialist_knowledge
    assert_equal 3, @assessment.reviewed_answerability
    assert_equal 2, @fact.reload.specialist_knowledge
    assert_equal 3, @fact.answerability
  end

  test "stale assessment can only be returned for reassessment" do
    @fact.update!(prompt: "What did the revised official evidence show?")

    patch moderator_calibration_assessment_path(@assessment), params: {
      fact_question_calibration_assessment: { decision: "accept" }
    }
    assert_redirected_to moderator_calibration_review_path(@opinion)
    assert @assessment.reload.ai_proposed?

    patch moderator_calibration_assessment_path(@assessment), params: {
      fact_question_calibration_assessment: {
        decision: "reassess",
        review_notes: "The question changed after the AI assessment."
      }
    }
    assert @assessment.reload.reassessment_requested?
  end

  private

  def create_assessment
    @fact.calibration_assessments.create!(
      content_fingerprint: FactQuestionCalibrationAudit.fingerprint(@fact),
      specialist_knowledge: 3,
      specialist_knowledge_rationale: "The fact requires focused policy reading.",
      specialist_knowledge_confidence: 4,
      answerability: 4,
      answerability_rationale: "Several credible alternatives require substantive reading.",
      answerability_confidence: 4,
      assessor_name: "Test AI",
      run_identifier: "supervision-test",
      submitted_by: @moderator
    )
  end
end
