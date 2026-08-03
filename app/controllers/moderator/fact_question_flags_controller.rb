module Moderator
  class FactQuestionFlagsController < BaseController
    def update
      flag = FactQuestionFlag.find(params[:id])
      FactQuestionFlag.transaction do
        apply_outcome!(flag)
      end
      redirect_to moderator_root_path, notice: outcome_notice
    rescue ActiveRecord::RecordInvalid => error
      redirect_to moderator_root_path,
        alert: error.record.errors.full_messages.to_sentence
    end

    private

    def moderation_params
      @moderation_params ||= params.require(:fact_question_flag).permit(:outcome, :resolution_notes)
    end

    def fact_question_params
      @fact_question_params ||= params.require(:fact_question).permit(
        :prompt, :correct_option, :explanation, :source_name, :source_url,
        :importance_weight, :importance_rationale, :evidence_direction,
        :specialist_knowledge, :answerability,
        options: []
      ).tap { _1[:options] = Array(_1[:options]).map(&:strip) }
    end

    def apply_outcome!(flag)
      case outcome
      when "corrected"
        flag.fact_question.update!(fact_question_params.merge(withdrawn_at: nil))
        complete!(flag, status: :resolved, resolution_action: :corrected)
      when "withdrawn"
        flag.fact_question.update!(withdrawn_at: Time.current)
        flag.fact_question.opinion_question.unpublish_if_fact_bank_not_ready!
        complete!(flag, status: :resolved, resolution_action: :withdrawn)
      else
        complete!(flag, status: :dismissed, resolution_action: :no_change)
      end
    end

    def complete!(flag, status:, resolution_action:)
      flag.update!(
        status: status,
        resolution_action: resolution_action,
        resolution_notes: moderation_params[:resolution_notes],
        reviewer: current_user,
        reviewed_at: Time.current
      )
    end

    def outcome
      moderation_params.fetch(:outcome).tap do |value|
        raise ActionController::BadRequest unless %w[corrected withdrawn dismissed].include?(value)
      end
    end

    def outcome_notice
      {
        "corrected" => "The fact question has been corrected and the report resolved.",
        "withdrawn" => "The fact question has been withdrawn and the report resolved.",
        "dismissed" => "The report has been dismissed without changing the fact question."
      }.fetch(outcome)
    end
  end
end
