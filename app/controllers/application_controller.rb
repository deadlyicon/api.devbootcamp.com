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

  def render_error status, json={}
    json[:status] = status
    json[:errors] ||= []
    render json: json, status: status
  end

  def render_bad_request json={errors: ["Bad Request"]}
    render_error 400, json
  end

  def render_unauthorize json={errors: ["Unauthorized"]}
    render_error 401, json
  end

  def render_exception exception
    render_error 500, errors: [exception.message]
  end

end
