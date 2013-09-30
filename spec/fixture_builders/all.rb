FixtureBuilder.build do

  san_francisco = create 'dbc/location', name: 'San Francisco'
  chicago       = create 'dbc/location', name: 'Chicago'

  create 'dbc/user', admin: true, name: 'Jared Grippe',    email: 'jared@devbootcamp.com'
  create 'dbc/user', admin: true, name: 'Sherif Abushadi', email: 'sherif@devbootcamp.com'

  beginning_of_week = Date.today.beginning_of_week

  5.times do |i|

    start_date = beginning_of_week - (3*i).weeks

    cohort = create 'dbc/cohort', {
      start_date: start_date,
      location: san_francisco,
    }

    25.times{ create 'dbc/user', student: true, cohort: cohort }
  end


  user_ids = Dbc::User.select(:id).all.map(&:id)

  10.times do
    Dbc::UserGroup.for user_ids.sample(rand(3)+1)
  end


  create 'dbc/user', editor: true

  # binding.pry

end
