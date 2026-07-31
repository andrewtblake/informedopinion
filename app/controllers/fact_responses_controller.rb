class FactResponsesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_opinion_question

  def create
    current_user.user_opinions.find_by!(opinion_question: @opinion_question)
    fact_question = @opinion_question.fact_questions.find(params[:fact_question_id])
    response = record_response(fact_question)

    if response.persisted?
      redirect_to opinion_question_quiz_path(@opinion_question, feedback: response.id),
        status: :see_other
    else
      redirect_to opinion_question_quiz_path(@opinion_question),
        alert: response.errors.full_messages.to_sentence,
        status: :see_other
    end
  end

  private

  def set_opinion_question
    @opinion_question = OpinionQuestion.find_by!(slug: params[:opinion_question_slug])
  end

  def record_response(fact_question)
    response = current_user.fact_responses.find_or_initialize_by(fact_question: fact_question)
    before = OpinionProgress.new(current_user, @opinion_question).weight

    FactResponse.transaction do
      response.assign_attributes(
        selected_option: params[:selected_option],
        attempt_count: response.attempt_count + 1,
        weight_before: before,
        weight_after: before,
        answered_at: Time.current
      )
      response.save!
      response.update!(weight_after: OpinionProgress.new(current_user, @opinion_question).weight)
    end

    response
  rescue ActiveRecord::RecordInvalid
    response
  end
end
