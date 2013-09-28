Module.new do

  extend FactoryGirl::Syntax::Methods

  def self.call

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

    binding.pry
  end

end.call
