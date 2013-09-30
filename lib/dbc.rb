class Dbc

  def self.as *user_ids
    new as: user_ids
  end

  def initialize options={}
    @current_user_group = UserGroup.for(options[:as])
  end

  attr_reader :current_user_group

  def users
    @users ||= Users.new(self)
  end

  delegate :roles, :can?, :cannot?, :can!, :cannot!, to: :current_user_group

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
