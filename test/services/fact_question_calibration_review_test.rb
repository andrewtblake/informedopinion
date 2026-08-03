require "test_helper"

class FactQuestionCalibrationReviewTest < ActiveSupport::TestCase
  test "sample includes mandatory cases, rating strata and an additional deterministic sample" do
    category = Category.create!(name: "Sample policy", slug: "sample-policy")
    opinion = OpinionQuestion.create!(category: category, title: "Sampling", statement: "The policy should be adopted.",
      slug: "sampling", display_order: 1, accent: "slate",
      response_options: PublishOpinionQuestionProposal::RESPONSE_OPTIONS)
    moderator = create_user!(email: "sample-moderator@example.test", password: "password123",
      first_name: "Sample", last_name: "Moderator", role: :moderator)
    ratings = [ [ 1, 4, 5 ], [ 3, 3, 4 ], [ 3, 3, 4 ], [ 4, 2, 2 ] ]
    assessments = ratings.each_with_index.map do |(specialist, answerability, confidence), index|
      fact = opinion.fact_questions.create!(prompt: "Sample fact #{index}?", options: %w[A B C D], correct_option: 0,
        explanation: "A is correct.", source_name: "Source", source_url: "https://example.test/#{index}",
        importance_weight: 1, importance_rationale: "Supporting.", evidence_direction: 0, display_order: index + 1)
      fact.calibration_assessments.create!(content_fingerprint: FactQuestionCalibrationAudit.fingerprint(fact),
        specialist_knowledge: specialist, specialist_knowledge_rationale: "Specialist rationale.",
        specialist_knowledge_confidence: confidence, answerability: answerability,
        answerability_rationale: "Answerability rationale.", answerability_confidence: confidence,
        assessor_name: "Test AI", run_identifier: "sample-run", submitted_by: moderator)
    end

    review = FactQuestionCalibrationReview.new(opinion)
    sample = review.supervisory_sample

    assert_includes sample, assessments.first
    assert_includes sample, assessments.last
    assert_equal 2, sample.count { _1.specialist_knowledge == 3 && _1.answerability == 3 }
  end
end
