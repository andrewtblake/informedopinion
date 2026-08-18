class OpinionQuestionProposalsController < ApplicationController
  def index
    @proposal = current_user ? current_user.opinion_question_proposals.new : OpinionQuestionProposal.new
    set_page_data
  end

  def new
    redirect_to opinion_question_proposals_path
  end

  def sign_in
    store_proposals_destination
    redirect_to new_user_session_path
  end

  def register
    store_proposals_destination
    redirect_to new_user_registration_path
  end

  def create
    unless user_signed_in?
      store_proposals_destination
      redirect_to new_user_session_path,
        alert: "Sign in or create an account to send your proposal. Your draft will remain in this browser."
      return
    end

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

  def store_proposals_destination
    store_location_for(:user, opinion_question_proposals_path)
  end

  def set_page_data
    @categories = Category.order(:name)
    @proposals = if current_user
      current_user.opinion_question_proposals.includes(:category).order(created_at: :desc)
    else
      OpinionQuestionProposal.none
    end
  end
end
