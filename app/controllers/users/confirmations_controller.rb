module Users
  class ConfirmationsController < Devise::ConfirmationsController
    def create
      super do |user|
        session[:pending_confirmation_user_id] = user.id if user.persisted?
      end
    end

    def show
      self.resource = resource_class.confirm_by_token(params[:confirmation_token])

      if resource.errors.empty?
        session.delete(:pending_confirmation_user_id)
        sign_in(resource_name, resource)
        redirect_to stored_location_for(resource_name) || root_path,
          notice: "Email verified. Welcome to #{current_site.name}."
      else
        respond_with_navigational(resource.errors, status: :unprocessable_content) { render :new }
      end
    end

    protected

    def after_resending_confirmation_instructions_path_for(_resource_name)
      pending_user_confirmation_path
    end
  end
end
