class Dbc::Cohort < ActiveRecord::Base

  has_many :members, class_name: 'Dbc::User'
  belongs_to :location

  def location= location
    location = Dbc::Location.where(name:location).first! if !location.is_a? Dbc::Location
    super location
  end

end
