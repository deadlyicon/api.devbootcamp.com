class Dbc::Cohorts

  include Dbc::Dependant

  MUTABLE_ATTRIBUTES = [
    :name,
    :location_id,
    :in_session,
    :start_date,
    :email,
    :visible,
    :slug,
  ]

  def all
    can! :index, :cohorts
    serialize Dbc::Cohort.all
  end

  def create attributes={}
    can! :create, :cohorts
    sanatize_attributes(attributes)
    cohort = Dbc::Cohort.create(attributes)
    return serialize(cohort) if cohort.errors.empty?
    raise Dbc::ValidationError, serialize(cohort)
  end

  def show id
    can! :show, :cohort, id: id
    cohort = Dbc::Cohort.find(id)
    serialize cohort
  end

  def update id, attributes={}
    can! :update, :cohort, id: id

    sanatize_attributes(attributes)
    cohort = Dbc::Cohort.find(id)
    cohort.update_attributes(attributes)
    return serialize(cohort) if cohort.errors.empty?
    raise Dbc::ValidationError, serialize(cohort)
  end

  def destroy id
    can! :destroy, :cohort, id: id
    cohort = Dbc::Cohort.find(id)
    cohort.destroy
    serialize cohort
  end

  def sanatize_attributes(attributes)
    attributes.to_hash.symbolize_keys!.slice! *MUTABLE_ATTRIBUTES
  end

  def serializer
    @serializer ||= Serializer.new(@dbc)
  end

  def serialize cohort_or_cohorts
    if cohort_or_cohorts.respond_to? :map
      cohort_or_cohorts.map(&serializer)
    else
      serializer.serialize(cohort_or_cohorts)
    end
  end

end
