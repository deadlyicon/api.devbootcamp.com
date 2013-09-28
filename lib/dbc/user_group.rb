class Dbc::UserGroup < ActiveRecord::Base

  has_many :challenge_attempts
  has_and_belongs_to_many :users

  def self.for user_ids
    user_ids = user_ids.map do |user_id|
      user_id.respond_to?(:id) ? user_id.id : user_id
    end
    record = joins(:users).where(users:{id:user_ids}).first
    record ? record : create!(user_ids: user_ids)
  end

  # scope :for_user_ids, -> (user_ids) do
  #   joins(:users).where(users:{id:user_ids})
  # end

  # scope :for_users, -> users do
  #   for_user_ids(users.map(&:id))
  # end

  # def user_ids
  #   user_ids = read_attribute(:user_ids) or return []
  #   user_ids.split(',').map(&:to_i)
  # end

  # def user_ids= user_ids
  #   write_attribute(:user_ids, '|'+user_ids.sort.join('|')+'|')
  # end


end
