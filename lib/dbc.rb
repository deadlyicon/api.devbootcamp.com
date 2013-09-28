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

  def current_users
    @current_users ||= User.where(:id => @current_user_ids).to_a
  end

end
