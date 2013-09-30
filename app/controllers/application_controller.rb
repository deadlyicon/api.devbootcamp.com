class ApplicationController < ActionController::Base

  respond_to :json

  before_action :force_request_formats_to_json!
  before_action :authenticate!

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

end
