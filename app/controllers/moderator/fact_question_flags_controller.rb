module Moderator
  class FactQuestionFlagsController < BaseController
    def update
      flag = FactQuestionFlag.find(params[:id])
      flag.update!(
        status: moderation_params.fetch(:status),
        resolution_notes: moderation_params[:resolution_notes],
        reviewer: current_user,
        reviewed_at: Time.current
      )
      redirect_to moderator_root_path, notice: "The fact report has been reviewed."
    end

    private

    def moderation_params
      params.require(:fact_question_flag).permit(:status, :resolution_notes)
    end
  end
end
