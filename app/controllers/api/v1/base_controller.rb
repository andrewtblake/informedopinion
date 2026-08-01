class Api::V1::BaseController < ActionController::API
  before_action :authenticate_moderator_token!

  rescue_from ActiveRecord::RecordNotFound, with: :not_found
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  rescue_from ActionController::ParameterMissing, with: :invalid_parameters

  private

  attr_reader :current_api_token, :current_moderator

  def authenticate_moderator_token!
    plaintext = request.authorization.to_s.match(/\ABearer\s+(.+)\z/i)&.captures&.first
    @current_api_token = ModeratorApiToken.authenticate(plaintext)
    @current_moderator = @current_api_token&.user
    unless @current_moderator&.moderator?
      response.set_header("WWW-Authenticate", 'Bearer realm="Informed Opinion moderator API"')
      return render json: { error: "unauthorized" }, status: :unauthorized
    end

    @current_api_token.update_column(:last_used_at, Time.current)
  end

  def audit!(action:, resource:, changes: {})
    ApiAuditEvent.create!(
      actor: current_moderator,
      moderator_api_token: current_api_token,
      action: action,
      resource_type: resource.class.name,
      resource_id: resource.id,
      request_id: request.request_id,
      change_data: changes
    )
  end

  def not_found
    render json: { error: "not_found" }, status: :not_found
  end

  def invalid_record(error)
    render json: { error: "validation_failed", details: error.record.errors.to_hash }, status: :unprocessable_entity
  end

  def invalid_parameters(error)
    render json: { error: "invalid_parameters", details: error.message }, status: :bad_request
  end
end
