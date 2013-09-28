class Dbc::Cohort < ActiveRecord::Base

  has_many :members, class_name: 'Dbc::User'
  belongs_to :location

end
