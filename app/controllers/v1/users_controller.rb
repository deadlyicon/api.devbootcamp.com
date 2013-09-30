class V1::UsersController < V1Controller

  rescue_from Dbc::ValidationError,  with: :render_validation_error
  rescue_from Dbc::PermissionsError, with: :render_permissions_error

  def index
    render json: dbc.users.all
  end

  def create
    user = dbc.users.create(user_params)
    render json: user, location: v1_user_url(user["id"])
  end

  def show
    render json: dbc.users.show(user_id)
  end

  def update
    render json: dbc.users.update(user_id, user_params)
  end

  def destroy
    render json: dbc.users.destroy(user_id)
  end

  private

  def user_id
    params[:id]
  end

  def user_params
    params.require(:user).permit!
  end

  def render_validation_error error
    render json: error.record, status: :bad_request
  end

  def render_permissions_error error
    render nothing: true, status: 401
  end

end
