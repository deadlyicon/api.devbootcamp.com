class ApplicationController < ActionController::Base

  respond_to :json

  before_action :force_request_formats_to_json!
  before_action :authenticate!

  private

  def force_request_formats_to_json!
    request.env["action_dispatch.request.formats"] = [Mime[:json]]
  end

  def authenticate!
    access_token = params[:access_token] || request.headers.env['HTTP_AUTHORIZATION']

    user = Dbc.authenticate_via_access_token(access_token) if access_token

    user ||= authenticate_with_http_basic do |email, password|
      user = Dbc.authenticate_via_email_and_password(access_token)
    end

    binding.pry

    render nothing: true, status: 401
  end

  def current_user_ids
    Array(session[:current_user_ids]).flatten
  end

  def dbc
    return nil if current_user_ids.empty?
    @dbc ||= Dbc.as(current_user_ids)
  end

end
