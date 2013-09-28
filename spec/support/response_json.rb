class ActionDispatch::TestResponse

  def json
    return @json if defined? @json
    @json = JSON.parse(body)
  end

end
