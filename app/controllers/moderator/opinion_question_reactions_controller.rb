module Moderator
  class OpinionQuestionReactionsController < BaseController
    def update
      reaction = OpinionQuestionReaction.dislike.find(params[:id])
      reaction.update!(
        moderation_status: decision,
        moderation_notes: params.dig(:opinion_question_reaction, :moderation_notes),
        reviewer: current_user,
        reviewed_at: Time.current
      )
      redirect_to moderator_root_path(anchor: "opinion-question-reactions"),
        notice: "The anonymous dislike has been #{decision}."
    end

    private

    def decision
      params.require(:opinion_question_reaction).fetch(:moderation_status).tap do |value|
        raise ActionController::BadRequest unless %w[reviewed dismissed].include?(value)
      end
    end
  end
end
