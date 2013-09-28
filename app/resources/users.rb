class Users < Resource

  def index
    User.all.as_json
  end

  def create attributes={}
    User.create!(attributes).as_json
  end

  def new attributes={}
    User.new(attributes).as_json
  end

  def show id
    User.find(id).as_json
  end

  def update id, attributes={}
    user = User.find(id)
    user.update_attributes(attributes)
    user.as_json
  end

  def destroy id
    User.find(id).destroy.as_json
  end

end
