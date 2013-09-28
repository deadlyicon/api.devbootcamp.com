class Dbc

  def self.as *user_ids
    new as: user_ids
  end

  def initialize options={}
    user_ids = Array(options[:as])
    @current_user_group = UserGroup.for(user_ids)
  end

  attr_reader :current_user_group

  def users
    @users ||= Users.new(self)
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
