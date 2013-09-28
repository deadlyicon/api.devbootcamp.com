module DbcHelpers

  def current_user_ids
    []
  end

  def dbc
    @dbc ||= Dbc.new as: current_user_ids
  end

end
