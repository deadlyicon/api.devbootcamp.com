class V1::MeController < V1Controller

  def show
    render json: dbc.user_groups.show(dbc.user_group.id)
  end

end
