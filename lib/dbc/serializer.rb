class Dbc::Serializer

  include Dbc::Dependant

  def to_proc
    @to_proc ||= method(:serialize).to_proc
  end

  def serialize
    raise "subclass should impliment serialize"
  end

end
