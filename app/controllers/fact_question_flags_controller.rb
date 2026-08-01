class FactQuestionFlagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_fact_question

  def new
    @flag = current_user.fact_question_flags.new(fact_question: @fact_question)
  end

  def create
    @flag = current_user.fact_question_flags.new(flag_params.merge(fact_question: @fact_question))
    if @flag.save
      redirect_to opinion_question_quiz_path(@fact_question.opinion_question),
        notice: "The fact question has been sent for moderator review."
    else
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_fact_question
    @fact_question = FactQuestion.published.includes(:opinion_question).find(params[:fact_question_id])
  end

  def flag_params
    params.require(:fact_question_flag).permit(:category, :details)
  end
end
