class OpinionQuestionProposalsController < ApplicationController
  before_action :authenticate_user!

  def index
    @proposal = current_user.opinion_question_proposals.new
    set_page_data
  end

  def new
    redirect_to opinion_question_proposals_path
  end

  def create
    @proposal = current_user.opinion_question_proposals.new(proposal_params)
    if @proposal.save
      redirect_to opinion_question_proposals_path, notice: "Your proposed opinion question has been sent for moderator review."
    else
      set_page_data
      render :index, status: :unprocessable_content
    end
  end

  private

  def proposal_params
    params.require(:opinion_question_proposal)
      .permit(:title, :statement, :category_id, :tags_text, :geographic_scope, :rationale)
  end

  def set_page_data
    @categories = Category.order(:name)
    @proposals = current_user.opinion_question_proposals
      .includes(:category)
      .order(created_at: :desc)
  end
end
