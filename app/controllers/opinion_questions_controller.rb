class OpinionQuestionsController < ApplicationController
  before_action :set_opinion_question, only: :show

  def index
    redirect_to root_path
  end

  def show
    @collective = CollectiveOpinion.new(@opinion_question)
    return unless user_signed_in?

    @user_opinion = current_user.user_opinions.find_by(opinion_question: @opinion_question)
    @reaction = current_user.opinion_question_reactions.find_by(opinion_question: @opinion_question)
    @progress = OpinionProgress.new(current_user, @opinion_question)
    @fact_proposal_eligibility = FactQuestionProposalEligibility.new(current_user, @opinion_question)
  end

  private

  def set_opinion_question
    scope = current_user&.moderator? ? OpinionQuestion.all : OpinionQuestion.live
    @opinion_question = scope.find_by!(slug: params[:slug])
  end
end
