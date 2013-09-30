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

    @dbc = Dbc.authenticate_via_access_token(access_token) if access_token

    @dbc ||= authenticate_with_http_basic do |email, password|
      Dbc.authenticate_via_email_and_password(email, password)
    end

    render nothing: true, status: 401 if @dbc.blank?
  end

  attr_reader :dbc


end
