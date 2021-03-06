module Dbc::User::Roles

  extend ActiveSupport::Concern

  # only add new roles at the end of the array
  ROLES = %w( student editor admin )

  def self.role_to_mask role
    index = ROLES.index(role.to_s)
    index or raise ArgumentError, "invalid role #{role.inspect}. Expected one of: #{ROLES.inspect}"
    2**index
  end

  with_role_where_sql = -> role do
    # some bitwise math going on here.
    # 001 is the 'student' role, 1 in decimal or 2**0
    # 010 is the 'editor' role, 2 in decimal or 2**1
    # 100 is the 'admin' role, 4 in decimal or 2**2
    # so a user whose role_mask = 7 would look like 111 in binary
    # which is to say they have all 3 roles
    # more here:  http://en.wikipedia.org/wiki/Mask_%28computing%29
    %("users"."roles_mask" & #{Dbc::User::Roles.role_to_mask(role)} > 0)
  end

  included do

    scope :with_role, -> role { where(with_role_where_sql[role]) }

    ROLES.each{|role| scope role, -> { with_role(role) } }

    scope :staff, -> { where "#{with_role_where_sql['editor']} OR #{with_role_where_sql['admin']}" }
    scope :not_disabled, -> { where(:disabled_at => nil) }
    scope :in_cohort, ->(cohort_id) { where(:cohort_id => cohort_id) }
  end

  def roles_mask
    read_attribute(:roles_mask) || 0
  end

  def roles
    ROLES.reject do |role|
      (roles_mask & Dbc::User::Roles.role_to_mask(role)).zero?
    end
  end

  def roles=(roles)
    roles = roles.split(/\s+/) if roles.is_a? String
    roles.map!(&:to_s)
    self.roles_mask = (roles & ROLES).map(&Dbc::User::Roles.method(:role_to_mask)).sum
  end

  def has_role?(role)
    roles.include?(role)
  end

  ROLES.each do |role|
    define_method "#{role}?" do
      has_role?(role)
    end
  end

end
