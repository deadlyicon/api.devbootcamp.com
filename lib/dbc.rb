class Dbc

  def self.as *user_ids
    new as: user_ids
  end

  def initialize options={}
    @current_user_ids = Array(options[:as])
  end

  def users
    @users ||= Users.new(self)
  end

  def current_user_group
    @current_user_group ||= UserGroup.for(@current_user_ids)
  end

  def current_users
    current_user_group.users
  end

  class ValidationError < StandardError
    def initialize(record)
      @record = record
    end
    attr_reader :record
  end

  class PermissionsError < StandardError
    def initialize(user_group)
      @record = record
    end
    attr_reader :record
  end

end
