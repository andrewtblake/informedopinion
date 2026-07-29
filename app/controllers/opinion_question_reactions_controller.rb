class OpinionQuestionReactionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_opinion_question

  def create
    reaction = current_user.opinion_question_reactions
      .find_or_initialize_by(opinion_question: @opinion_question)
    if reaction.update(reaction_params)
      redirect_to opinion_question_path(@opinion_question), notice: "Your response has been recorded."
    else
      redirect_to opinion_question_path(@opinion_question),
        alert: reaction.errors.full_messages.to_sentence
    end
  end

  def destroy
    current_user.opinion_question_reactions
      .find_by(opinion_question: @opinion_question)
      &.destroy
    redirect_to opinion_question_path(@opinion_question), notice: "Your response has been removed."
  end

  private

  def set_opinion_question
    @opinion_question = OpinionQuestion.find_by!(slug: params[:opinion_question_slug])
  end

  def reaction_params
    params.require(:opinion_question_reaction).permit(:kind, :reason)
  end
end
