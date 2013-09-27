class ApplicationController < ActionController::Base

  respond_to :json

  before_action do |controller|
    controller.request.env["action_dispatch.request.formats"] = [Mime[:json]]
  end

end
