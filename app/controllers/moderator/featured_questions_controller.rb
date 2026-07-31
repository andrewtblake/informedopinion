module Moderator
  class FeaturedQuestionsController < BaseController
    def update
      question = OpinionQuestion.live.find_by!(slug: params[:id])
      question.with_lock do
        question.update!(featured_priority: revised_priority(question))
      end

      redirect_to moderator_root_path(anchor: "featured-order"),
        notice: "The featured-order adjustment has been updated."
    end

    private

    def revised_priority(question)
      return 0 if params[:adjustment] == "reset"

      delta = Integer(params[:adjustment], exception: false)
      raise ActionController::BadRequest unless [ -1, 1 ].include?(delta)

      (question.featured_priority + delta).clamp(-10, 10)
    end
  end
end
