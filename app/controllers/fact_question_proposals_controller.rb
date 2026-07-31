class FactQuestionProposalsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_opinion_question
  before_action :require_eligibility!

  def new
    @proposal = current_user.fact_question_proposals.new(opinion_question: @opinion_question)
    @previous_proposals = previous_proposals
  end

  def create
    @proposal = current_user.fact_question_proposals.new(
      proposal_params.merge(opinion_question: @opinion_question)
    )
    if @proposal.save
      if current_user.moderator?
        PublishFactQuestionProposal.new(
          proposal: @proposal,
          reviewer: current_user,
          attributes: proposal_params
        ).call
        redirect_to opinion_question_path(@opinion_question), notice: "The fact question has been added."
      else
        redirect_to opinion_question_path(@opinion_question),
          notice: "Your fact question has been sent for moderator review."
      end
    else
      @previous_proposals = previous_proposals
      render :new, status: :unprocessable_content
    end
  end

  private

  def set_opinion_question
    scope = current_user.moderator? ? OpinionQuestion.all : OpinionQuestion.live
    @opinion_question = scope.find_by!(slug: params[:opinion_question_slug])
  end

  def require_eligibility!
    @eligibility = FactQuestionProposalEligibility.new(current_user, @opinion_question)
    return if @eligibility.eligible?

    redirect_to opinion_question_path(@opinion_question), alert: @eligibility.explanation
  end

  def proposal_params
    permitted = params.require(:fact_question_proposal).permit(
      :prompt, :correct_option, :explanation, :source_name, :source_url,
      :importance_weight, :importance_rationale, :evidence_direction,
      options: []
    )
    permitted[:options] = Array(permitted[:options]).map(&:strip)
    permitted
  end

  def previous_proposals
    current_user.fact_question_proposals
      .where(opinion_question: @opinion_question)
      .order(created_at: :desc)
  end
end
