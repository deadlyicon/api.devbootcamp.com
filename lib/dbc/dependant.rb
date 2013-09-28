module Dbc::Dependant

  def initialize dbc
    @dbc = dbc
  end

  delegate :current_users, to: :@dbc

end
