module Dbc::Dependant

  def initialize dbc
    @dbc = dbc
  end

  delegate :can?, :cannot?, :can!, :cannot!, to: :@dbc

end
