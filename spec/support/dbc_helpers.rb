module DbcHelpers

  def current_users
    []
  end

  def current_user_ids
    current_users.map(&:id)
  end

  def dbc
    @dbc ||= Dbc.new as: current_user_ids
  end

end
