class V1::UsersController < ApplicationController

  def index
    respond_with dbc.users.all
  end

  def create
    user = dbs.users.create(user_params)
    respond_with user, location: v1_user_url(user["id"])
  end

  def new
    respond_with dbs.users.new
  end

  def edit
    respond_with dbs.users.show(user_id)
  end

  def show
    respond_with dbs.users.show(user_id)
  end

  def update
    respond_with dbs.users.update(user_id, user_params)
  end

  def destroy
    respond_with dbs.users.destroy(user_id)
  end

  private

  def user_id
    params[:id]
  end

  def user_params
    params.require(:user).permit!
  end

end
