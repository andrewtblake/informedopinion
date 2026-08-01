class AccountsController < ApplicationController
  before_action :authenticate_user!

  def show
    set_account_counts
  end

  def consent
    unless ActiveModel::Type::Boolean.new.cast(params[:accept_terms])
      redirect_to account_path, alert: "Agreement to the current participation terms is required."
      return
    end

    unless ActiveModel::Type::Boolean.new.cast(params[:consent_sensitive_data])
      redirect_to account_path, alert: "Explicit consent is required to record topic opinions and answers."
      return
    end

    current_user.record_privacy_consent!
    redirect_to account_path, notice: "Your participation consent has been recorded."
  end

  def destroy
    unless params[:confirmation] == "DELETE"
      set_account_counts
      flash.now[:alert] = "Enter DELETE exactly to confirm account deletion."
      render :show, status: :unprocessable_content
      return
    end

    unless current_user.valid_password?(params[:current_password])
      set_account_counts
      flash.now[:alert] = "The current password was not correct."
      render :show, status: :unprocessable_content
      return
    end

    user = current_user
    user.destroy!
    sign_out user
    redirect_to root_path, notice: "Your account and associated participation data have been deleted."
  end

  private

  def set_account_counts
    @account_counts = {
      opinions: current_user.user_opinions.count,
      answers: current_user.fact_responses.count,
      reactions: current_user.opinion_question_reactions.count,
      reports: current_user.fact_question_flags.count,
      proposals: current_user.opinion_question_proposals.count + current_user.fact_question_proposals.count
    }
  end
end
