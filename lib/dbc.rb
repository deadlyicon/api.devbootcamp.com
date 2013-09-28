class Dbc

  def self.as *user_ids
    new as: user_ids
  end

  def initialize options={}
    @as = Array(options[:as])
  end

  def users
    @users ||= Users.new(self)
  end

end
