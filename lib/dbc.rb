class Dbc

  def self.as *user_ids
    new as: user_ids
  end

  def initialize options={}
    user_ids = Array(options[:as])
    raise ArgumentError, "as option must contain a valid set of user ids" if user_ids.empty?
    @current_user_group = UserGroup.for(user_ids) or
    @current_user_group or raise InvalidUserGroup
  end

  def users
    @users ||= Users.new(self)
  end

  def current_user_group
    @current_user_group ||= UserGroup.for(@current_user_ids)
  end

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
  end

end
