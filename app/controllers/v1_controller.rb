class V1Controller < ApplicationController

  private

  attr_reader :dbc

  def authenticate!
    if access_token.present?
      @dbc = Dbc.authenticate_via_access_token(access_token) and return
      return render_unauthorize "Invalid Access Token"
    end

    authenticate_with_http_basic do |email, password|
      if email.present? && password.present?
        @dbc = Dbc.authenticate_via_email_and_password(email, password) and return
        return render_unauthorize "Invalid Username or Password"
      end
    end

    render_unauthorize
  end

  def access_token
    access_token = params[:access_token] || request.headers.env['HTTP_AUTHORIZATION']
    access_token if access_token.present? && access_token !~ /basic/i
  end

end
