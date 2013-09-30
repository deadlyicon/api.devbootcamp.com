class Dbc::Users < Dbc::Resource

  permittable_attributes %w{
    name
    email
    password
    password_confirmation
    roles
    cohort_id
  }

end
