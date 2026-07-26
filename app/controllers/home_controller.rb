class HomeController < ApplicationController
  def index
    @opinion_questions = OpinionQuestion.in_display_order.includes(:fact_questions)
    return unless user_signed_in?

    @user_opinions = current_user.user_opinions.index_by(&:opinion_question_id)
    @progress_by_question = @opinion_questions.index_with do |question|
      OpinionProgress.new(current_user, question)
    end
  end
end
