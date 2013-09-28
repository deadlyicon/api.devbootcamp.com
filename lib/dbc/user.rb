class Dbc::User < ActiveRecord::Base

  has_secure_password

  belongs_to :cohort
  has_and_belongs_to_many :user_groups
  has_many :challenge_attempts

  validates :name,  presence: true
  validates :email, presence: true
  # validates :cohort_id, presence: true, if: ->{ student? }

end
