class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
  rescue_from ActionController::ParameterMissing, with: :render_bad_request

  private

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    payload = JwtService.decode(token)
    @current_user = User.find(payload["user_id"])
  rescue StandardError
    render json: { error: "Unauthorized" }, status: :unauthorized
  end

  def authenticate_user_optional!
    token = request.headers["Authorization"]&.split(" ")&.last
    return if token.blank?

    payload = JwtService.decode(token)
    @current_user = User.find(payload["user_id"])
  rescue StandardError
    @current_user = nil
  end

  def require_admin!
    return if current_user&.admin?

    render json: { error: "Forbidden" }, status: :forbidden
  end

  def current_user
    @current_user
  end

  def render_not_found(error)
    render json: { error: error.message }, status: :not_found
  end

  def render_unprocessable_entity(error)
    render json: { error: error.record.errors.full_messages }, status: :unprocessable_entity
  end

  def render_bad_request(error)
    render json: { error: error.message }, status: :bad_request
  end
end
