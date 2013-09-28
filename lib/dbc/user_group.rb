class Dbc::UserGroup < ActiveRecord::Base

  has_many :challenge_attempts
  has_and_belongs_to_many :users

  validates_length_of :user_ids, minimum: 1
  validates_presence_of :users_count

  before_validation :count_users

  def self.for user_ids
    return nil if user_ids.blank?
    user_ids = user_ids.map do |user_id|
      user_id.respond_to?(:id) ? user_id.id : user_id
    end
    record = joins(:users).where(users:{id:user_ids}).first
    record ? record : create!(user_ids: user_ids)
  end

  def roles
    @roles ||= users.map(&:roles).sum.uniq
  end

  def has_role?(role)
    roles.include?(role)
  end

  Dbc::User::Roles::ROLES.each do |role|
    define_method "#{role}?" do
      has_role?(role)
    end
  end

  def ability
    @ability ||= Ability.new self
  end

  delegate :can?, :cannot?, to: :ability

end
