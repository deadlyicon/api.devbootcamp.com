class V1::UsersController < ApplicationController

  def index
    respond_with Users.index
  end

  def create
    user = Users.create(user_params)
    respond_with user, location: v1_user_url(user["id"])
  end

  def new
    respond_with Users.new
  end

  def edit
    respond_with Users.show(user_id)
  end

  def show
    respond_with Users.show(user_id)
  end

  def update
    respond_with Users.update(user_id, user_params)
  end

  def destroy
    respond_with Users.destroy(user_id)
  end

  private

  def user_id
    params[:id]
  end

  def user_params
    params.require(:user).permit(%w{
      name
      email
      password
      password_confirmation
      roles
      github_token
    })
  end

end
