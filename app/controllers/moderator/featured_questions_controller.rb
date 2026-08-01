module Moderator
  class FeaturedQuestionsController < BaseController
    def update
      question = OpinionQuestion.live.find_by!(slug: params[:id])
      question.with_lock do
        question.update!(featured_priority: revised_priority(question))
      end

      respond_to do |format|
        format.turbo_stream do
          ranker = FeaturedQuestionRanker.new(OpinionQuestion.live.includes(:category).to_a)
          render turbo_stream: turbo_stream.replace(
            "featured-order-content",
            partial: "moderator/dashboard/featured_order",
            locals: { featured_questions: ranker.rank, featured_ranker: ranker }
          )
        end
        format.html do
          redirect_to moderator_root_path(anchor: "featured-order"),
            notice: "The featured-order adjustment has been updated."
        end
      end
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
