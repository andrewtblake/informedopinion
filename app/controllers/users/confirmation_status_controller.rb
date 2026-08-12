module Users
  class ConfirmationStatusController < ApplicationController
    skip_before_action :require_current_privacy_consent

    def show
      redirect_to root_path if user_signed_in?
    end

    def status
      user = pending_user
      render json: {
        confirmed: user_signed_in? || user&.confirmed? || false,
        signed_in: user_signed_in?,
        continue_url: root_path
      }
    end

    private

    def pending_user
      User.find_by(id: session[:pending_confirmation_user_id])
    end
  end
end
