class Dbc::UserGroup < ActiveRecord::Base

  has_many :challenge_attempts

end
