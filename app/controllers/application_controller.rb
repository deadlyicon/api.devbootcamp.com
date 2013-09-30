class ApplicationController < ActionController::Base

  respond_to :json

  before_action :force_request_formats_to_json!
  before_action :authenticate!

  rescue_from Exception, :with => :render_exception
  rescue_from ActionController::ParameterMissing, :with => :render_parameter_missing
  rescue_from ActiveRecord::RecordNotFound, :with => :render_record_not_found

  private

  def force_request_formats_to_json!
    request.env["action_dispatch.request.formats"] = [Mime[:json]]
  end

  def authenticate!
    render_unauthorized error="Unauthorized"
  end

  def render_error status, json={}
    json[:status] = status
    json[:errors] ||= []
    render json: json, status: status
  end

  def render_bad_request json={errors: ["Bad Request"]}
    render_error 400, json
  end

  def render_unauthorized json={errors: ["Unauthorized"]}
    render_error 401, json
  end

  def render_not_found json={errors: ["Not Found"]}
    render_error 404, json
  end

  def render_exception exception
    render_error 500, errors: [exception.message], class: exception.class.to_s, backtrace: exception.backtrace
  end

  def render_parameter_missing error
    render_bad_request errors: [error.message]
  end

  def render_record_not_found error
    render_bad_request errors: [error.message]
  end

end
