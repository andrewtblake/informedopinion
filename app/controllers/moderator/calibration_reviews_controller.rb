module Moderator
  class CalibrationReviewsController < BaseController
    def index
      @reviews = OpinionQuestion.includes(fact_questions: :calibration_assessments).in_display_order.map do |question|
        FactQuestionCalibrationReview.new(question)
      end
    end

    def show
      @question = OpinionQuestion.includes(fact_questions: :calibration_assessments).find_by!(slug: params[:id])
      @review = FactQuestionCalibrationReview.new(@question)
      @current_assessment_ids = @review.latest_assessments.map(&:id)
      @scope = %w[sample pending unfit all].include?(params[:scope]) ? params[:scope] : "sample"
      @assessments = case @scope
      when "pending" then @review.latest_assessments.select(&:ai_proposed?)
      when "unfit" then @review.latest_assessments.select { _1.answerability.zero? }
      when "all"
        @question.fact_questions.flat_map(&:calibration_assessments).sort_by { [ _1.fact_question.display_order, _1.created_at ] }
      else @review.supervisory_sample
      end
    end
  end
end
