class Dbc

  def self.authenticate_via_email_and_password email, password
    # return if email.blank? || password.blank?
    user = User.where(email: email).first or return
    user.authenticate(password) or return
    as UserGroup.for(user).user_ids
  end

  def self.authenticate_via_access_token access_token
    user_group = UserGroup.where(access_token: access_token).first or return
    as user_group.user_ids
  end

  def self.as *user_ids
    new as: user_ids
  end

  def initialize options={}
    @user_group = UserGroup.for(options[:as])
  end

  attr_reader :user_group

  def users
    @users ||= Users.new(self)
  end

  delegate :roles, :can?, :cannot?, :can!, :cannot!, to: :user_group

  class InvalidUserGroup < StandardError
    def initialize(record)
      @record = record
    end
    attr_reader :record
  end

  class ValidationError < StandardError
    def initialize(record)
      @record = record
    end
    attr_reader :record
  end

  class PermissionsError < StandardError
    def initialize user_group, can, action, subject
      super "users #{user_group.user_ids.inspect} with the roles #{user_group.roles.inspect} #{can} #{action} #{subject.inspect}"
    end
  end

end
