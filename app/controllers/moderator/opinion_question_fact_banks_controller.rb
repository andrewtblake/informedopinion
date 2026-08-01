module Moderator
  class OpinionQuestionFactBanksController < BaseController
    def show
      @question = OpinionQuestion.includes(:published_fact_questions).find_by!(slug: params[:opinion_question_id])
    end
  end
end
