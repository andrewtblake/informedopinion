class ApplicationController < ActionController::Base
  before_action :select_site_identity

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :require_current_privacy_consent

  helper_method :current_site

  protected

  def current_site
    @current_site ||= SiteIdentity::PRIMARY
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(
      :sign_up,
      keys: %i[first_name last_name accept_terms consent_sensitive_data]
    )
    devise_parameter_sanitizer.permit(:account_update, keys: %i[first_name last_name])
  end

  def require_current_privacy_consent
    return unless user_signed_in?
    return if current_user.privacy_consent_current?
    return if devise_controller? || controller_path.in?(%w[accounts pages])

    redirect_to account_path,
      alert: "Please review the current participation and privacy terms before continuing."
  end

  private

  def select_site_identity
    @current_site = if controller_path.start_with?("moderator/")
      SiteIdentity::PRIMARY
    else
      SiteIdentity.for_host(request.host)
    end
    request.variant = current_site.variant if current_site.variant
  end
end
