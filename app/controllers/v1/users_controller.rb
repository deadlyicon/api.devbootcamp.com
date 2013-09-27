class V1::UsersController < ApplicationController

  def index
    respond_with Users.index
  end

  def create
    respond_with Users.create(params[:user])
  end

  def new
    respond_with Users.new
  end

  def edit
    respond_with Users.show(params[:id])
  end

  def show
    respond_with Users.show(params[:id])
  end

  def update
    respond_with Users.update(params[:id], params[:user])
  end

  def destroy
    respond_with Users.destroy(params[:id])
  end

end
