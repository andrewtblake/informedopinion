class QuizzesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_opinion_question

  def show
    @user_opinion = current_user.user_opinions.find_by(opinion_question: @opinion_question)
    unless @user_opinion
      redirect_to opinion_question_path(@opinion_question),
        alert: "Register your opinion before starting the knowledge check."
      return
    end

    @progress = OpinionProgress.new(current_user, @opinion_question)
    @feedback = feedback_response
    @fact_question = @feedback&.fact_question || next_question
    @answer_choices = shuffled_answer_choices unless @feedback
  end

  private

  def set_opinion_question
    @opinion_question = OpinionQuestion.find_by!(slug: params[:opinion_question_slug])
  end

  def feedback_response
    return if params[:feedback].blank?

    current_user.fact_responses
      .joins(:fact_question)
      .where(fact_questions: { opinion_question_id: @opinion_question.id })
      .find(params[:feedback])
  end

  def next_question
    NextFactQuestion.new(
      user: current_user,
      opinion_question: @opinion_question,
      user_opinion: @user_opinion
    ).call
  end

  def shuffled_answer_choices
    @fact_question.options.each_with_index.map do |option, original_index|
      [ option, original_index ]
    end.shuffle
  end
end
