class V1::CohortsController < V1Controller

  def index
    render json: dbc.cohorts.all
  end

  def create
    cohort = dbc.cohorts.create(cohort_params)
    render json: cohort, location: v1_cohort_url(cohort["id"])
  end

  def show
    render json: dbc.cohorts.show(cohort_id)
  end

  def update
    render json: dbc.cohorts.update(cohort_id, cohort_params)
  end

  def destroy
    render json: dbc.cohorts.destroy(cohort_id)
  end

  private

  def cohort_id
    params[:id].to_i
  end

  def cohort_params
    params.require(:cohort).permit!
  end

end
