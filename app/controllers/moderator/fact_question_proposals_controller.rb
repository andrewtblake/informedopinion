module Moderator
  class FactQuestionProposalsController < BaseController
    def update
      proposal = FactQuestionProposal.pending.find(params[:id])
      if decision == "approved"
        PublishFactQuestionProposal.new(
          proposal: proposal,
          reviewer: current_user,
          attributes: editorial_attributes,
          review_notes: moderation_params[:review_notes]
        ).call
      else
        proposal.update!(
          status: :declined,
          reviewer: current_user,
          review_notes: moderation_params[:review_notes],
          reviewed_at: Time.current
        )
      end
      redirect_to moderator_root_path, notice: "The fact-question proposal has been reviewed."
    rescue ActiveRecord::RecordInvalid => error
      redirect_to moderator_root_path, alert: error.record.errors.full_messages.to_sentence
    end

    private

    def moderation_params
      @moderation_params ||= params.require(:fact_question_proposal).permit(
        :status, :review_notes, :prompt, :correct_option, :explanation,
        :source_name, :source_url, :importance_weight, :importance_rationale,
        :evidence_direction, options: []
      )
    end

    def editorial_attributes
      moderation_params.except(:status, :review_notes).tap do |attributes|
        attributes[:options] = Array(attributes[:options]).map(&:strip)
      end
    end

    def decision
      moderation_params.fetch(:status).tap do |value|
        raise ActionController::BadRequest unless %w[approved declined].include?(value)
      end
    end
  end
end
