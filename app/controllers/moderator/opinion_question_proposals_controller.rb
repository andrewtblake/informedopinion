module Moderator
  class OpinionQuestionProposalsController < BaseController
    def update
      proposal = OpinionQuestionProposal.find(params[:id])
      proposal.update!(
        status: moderation_params.fetch(:status),
        review_notes: moderation_params[:review_notes],
        reviewer: current_user,
        reviewed_at: Time.current
      )
      redirect_to moderator_root_path, notice: "The proposal has been reviewed."
    end

    private

    def moderation_params
      params.require(:opinion_question_proposal).permit(:status, :review_notes)
    end
  end
end
