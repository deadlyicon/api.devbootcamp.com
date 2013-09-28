class Dbc::User < ActiveRecord::Base

  include Dbc::User::Roles

  has_secure_password

  belongs_to :cohort
  has_and_belongs_to_many :user_groups
  has_many :challenge_attempts, through: :user_groups

  validates :name,  presence: true
  validates :email, presence: true
  # validates :cohort_id, presence: true, if: ->{ student? }

end

require 'dbc/user/serializer'
