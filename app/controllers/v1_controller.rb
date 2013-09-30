class V1Controller < ApplicationController

  rescue_from Dbc::ValidationError,  with: :render_validation_error
  rescue_from Dbc::PermissionsError, with: :render_permissions_error

  private

  attr_reader :dbc

  def authenticate!
    if access_token.present?
      @dbc = Dbc.authenticate_via_access_token(access_token) and return
      return render_unauthorized "Invalid Access Token"
    end

    authenticate_with_http_basic do |email, password|
      if email.present? && password.present?
        @dbc = Dbc.authenticate_via_email_and_password(email, password) and return
        return render_unauthorized "Invalid Username or Password"
      end
    end

    render_unauthorized
  end

  def access_token
    access_token = params[:access_token] || request.headers.env['HTTP_AUTHORIZATION']
    access_token if access_token.present? && access_token !~ /basic/i
  end

  def render_validation_error error
    render_bad_request errors: error.record["errors"]
  end

  def render_permissions_error error
    render_unauthorized
  end

  delegate :can?, :cannot?, :can!, :cannot!, to: :dbc

end
