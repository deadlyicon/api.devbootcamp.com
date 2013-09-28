class ApplicationController < ActionController::Base

  respond_to :json

  before_action do |controller|
    controller.request.env["action_dispatch.request.formats"] = [Mime[:json]]
  end

  def current_user_ids
    Array(session[:current_user_ids])
  end

  def dbc
    @dbc ||= Dbc.as(current_user_ids)
  end

end
