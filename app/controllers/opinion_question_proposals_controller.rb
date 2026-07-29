class OpinionQuestionProposalsController < ApplicationController
  before_action :authenticate_user!

  def new
    @proposal = current_user.opinion_question_proposals.new
    set_categories
  end

  def create
    @proposal = current_user.opinion_question_proposals.new(proposal_params)
    if @proposal.save
      redirect_to root_path, notice: "Your proposed opinion question has been sent for moderator review."
    else
      set_categories
      render :new, status: :unprocessable_content
    end
  end

  private

  def proposal_params
    params.require(:opinion_question_proposal)
      .permit(:title, :statement, :category_id, :tags_text, :geographic_scope, :rationale)
  end

  def set_categories
    @categories = Category.order(:name)
  end
end
