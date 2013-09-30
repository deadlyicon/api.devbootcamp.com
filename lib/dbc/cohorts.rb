class Dbc::Cohorts < Dbc::Resource

  permittable_attributes %w{
    name
    location
    in_session
    start_date
    email
    visible
    slug
  }

  def members id
    can! :show, :cohort, id: id
    cohort = model.find(id)
    cohort.members.map do |member|
      can! :show, :user, id: member.id
      dbc.users.serialize(member)
    end
  end

end
