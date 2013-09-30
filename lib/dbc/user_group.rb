class Dbc::UserGroup < ActiveRecord::Base

  class Invalid < StandardError
  end

  has_many :challenge_attempts
  has_and_belongs_to_many :users

  validates_presence_of :user_ids

  before_validation :serialize_user_ids
  before_validation :generate_access_token

  def self.for *user_ids
    user_ids = user_ids.flatten.map do |user_id|
      user_id.respond_to?(:id) ? user_id.id : user_id.to_i
    end.uniq
    raise Invalid, 'a user group must have at least 1 user' if user_ids.empty?
    record = where(:user_ids => user_ids.sort.join(',')).first
    record ? record : create!(user_ids: user_ids)
  rescue ActiveRecord::RecordNotFound
    raise Invalid, $!.message
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

  delegate :can?, :cannot?, to: :ability

  def can!(action, subject, conditions={})
    return if can? action, subject, conditions
    raise Dbc::PermissionsError.new(self, :cannot, action, subject, conditions)
  end

  def cannot!(action, subject, conditions={})
    return if cannot? action, subject, conditions
    raise Dbc::PermissionsError.new(self, :can, action, subject, conditions)
  end

  private

  def ability
    @ability ||= Dbc::Ability.new self
  end

  def serialize_user_ids
    write_attribute :user_ids, user_ids.sort.join(',')
  end

  def generate_access_token
    write_attribute :access_token, SecureRandom.uuid.gsub('-','')
  end

end
