module Moderator
  class CalibrationAssessmentsController < BaseController
    def update
      assessment = FactQuestionCalibrationAssessment.find(params[:id])
      ensure_current!(assessment)
      decision = review_params.require(:decision)
      stale = FactQuestionCalibrationReview.new(assessment.fact_question.opinion_question).stale?(assessment)
      if stale && decision != "reassess"
        return redirect_back fallback_location: moderator_calibration_review_path(assessment.fact_question.opinion_question),
          alert: "The fact question changed after this assessment. Request reassessment before accepting ratings."
      end

      FactQuestionCalibrationAssessment.transaction do
        case decision
        when "accept" then accept!(assessment)
        when "override" then override!(assessment)
        when "reassess" then request_reassessment!(assessment)
        else raise ActionController::BadRequest
        end
        record_audit!(assessment, decision)
      end
      redirect_to moderator_calibration_review_path(assessment.fact_question.opinion_question, scope: "sample"),
        notice: "The calibration assessment has been #{decision_notice(decision)}."
    rescue ActiveRecord::RecordInvalid => error
      redirect_back fallback_location: moderator_calibration_reviews_path,
        alert: error.record.errors.full_messages.to_sentence
    end

    private

    def review_params
      @review_params ||= params.require(:fact_question_calibration_assessment).permit(
        :decision, :reviewed_specialist_knowledge, :reviewed_answerability, :review_notes
      )
    end

    def ensure_current!(assessment)
      latest = assessment.fact_question.calibration_assessments.order(created_at: :desc, id: :desc).first
      raise ActiveRecord::RecordNotFound unless latest == assessment && assessment.ai_proposed?
    end

    def accept!(assessment)
      assessment.update!(
        status: :accepted,
        reviewed_specialist_knowledge: assessment.specialist_knowledge,
        reviewed_answerability: assessment.answerability,
        reviewer: current_user,
        review_notes: review_params[:review_notes],
        reviewed_at: Time.current
      )
      apply_reviewed_ratings!(assessment)
    end

    def override!(assessment)
      assessment.update!(
        status: :overridden,
        reviewed_specialist_knowledge: review_params.require(:reviewed_specialist_knowledge),
        reviewed_answerability: review_params.require(:reviewed_answerability),
        reviewer: current_user,
        review_notes: review_params.require(:review_notes),
        reviewed_at: Time.current
      )
      apply_reviewed_ratings!(assessment)
    end

    def request_reassessment!(assessment)
      assessment.update!(
        status: :reassessment_requested,
        reviewer: current_user,
        review_notes: review_params.require(:review_notes),
        reviewed_at: Time.current
      )
    end

    def apply_reviewed_ratings!(assessment)
      assessment.fact_question.update!(
        specialist_knowledge: assessment.reviewed_specialist_knowledge,
        answerability: assessment.reviewed_answerability
      )
    end

    def record_audit!(assessment, decision)
      ApiAuditEvent.create!(
        actor: current_user,
        action: "fact_question_calibration.#{decision}",
        resource_type: assessment.class.name,
        resource_id: assessment.id,
        request_id: request.request_id,
        change_data: {
          "ai_specialist_knowledge" => assessment.specialist_knowledge,
          "ai_answerability" => assessment.answerability,
          "reviewed_specialist_knowledge" => assessment.reviewed_specialist_knowledge,
          "reviewed_answerability" => assessment.reviewed_answerability,
          "review_notes" => assessment.review_notes
        }
      )
    end

    def decision_notice(decision)
      { "accept" => "accepted", "override" => "overridden", "reassess" => "returned for reassessment" }.fetch(decision)
    end
  end
end
