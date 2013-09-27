class Users

  def self.index
    User.all.as_json
  end

  def self.create attributes={}
    User.create!(attributes).as_json
  end

  def self.new attributes={}
    User.new(attributes).as_json
  end

  def self.show id
    User.find(id).as_json
  end

  def self.update id, attributes={}
    user = User.find(id)
    user.update_attributes(attributes)
    user.as_json
  end

  def self.destroy id
    User.find(id).destroy.as_json
  end

end
