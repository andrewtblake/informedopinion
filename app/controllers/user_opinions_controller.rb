class UserOpinionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_opinion_question

  def create
    opinion = current_user.user_opinions.new(opinion_params.merge(opinion_question: @opinion_question))

    if opinion.save
      redirect_to opinion_question_quiz_path(@opinion_question),
        notice: "Your opinion is registered. Now let’s find out how informed it is."
    else
      redirect_to opinion_question_path(@opinion_question),
        alert: opinion.errors.full_messages.to_sentence
    end
  end

  def update
    opinion = current_user.user_opinions.find_by!(opinion_question: @opinion_question)

    if opinion.update(opinion_params)
      redirect_to opinion_question_path(@opinion_question),
        notice: "Your opinion has been revised. Your knowledge weight is unchanged."
    else
      redirect_to opinion_question_path(@opinion_question),
        alert: opinion.errors.full_messages.to_sentence
    end
  end

  private

  def set_opinion_question
    @opinion_question = OpinionQuestion.find_by!(slug: params[:opinion_question_slug])
  end

  def opinion_params
    params.require(:user_opinion).permit(:position)
  end
end
