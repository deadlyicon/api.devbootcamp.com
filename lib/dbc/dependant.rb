module Dbc::Dependant

  def initialize dbc
    @dbc = dbc
  end

  attr_reader :dbc

  delegate :can?, :cannot?, :can!, :cannot!, to: :dbc

end
