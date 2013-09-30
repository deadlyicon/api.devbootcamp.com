class ApplicationController < ActionController::Base

  respond_to :json

  before_action :force_request_formats_to_json!
  before_action :authenticate!

  rescue_from Exception, :with => :render_exception

  private

  def force_request_formats_to_json!
    request.env["action_dispatch.request.formats"] = [Mime[:json]]
  end

  def authenticate!
    render_unauthorize error="Unauthorized"
  end

  def render_unauthorize error="Unauthorized"
    render json: {status: 401, error: error}, status: 401
  end

  def render_exception exception
    render json: {status: 500, error: exception.message}, status: 500
  end

end
