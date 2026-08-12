module Users
  class RegistrationsController < Devise::RegistrationsController
    protected

    def build_resource(hash = nil)
      super
      resource.require_participation_consent = true
    end

    def after_inactive_sign_up_path_for(resource)
      session[:pending_confirmation_user_id] = resource.id
      pending_user_confirmation_path
    end
  end
end
