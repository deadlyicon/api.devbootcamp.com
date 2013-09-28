Module.new do

  extend FactoryGirl::Syntax::Methods

  def self.call

    create 'dbc/user', admin: true, name: 'Jared Grippe',    email: 'jared@devbootcamp.com'
    create 'dbc/user', admin: true, name: 'Sherif Abushadi', email: 'sherif@devbootcamp.com'

    10.times do
      create 'dbc/user', student: true
    end

    binding.pry
  end

end.call
