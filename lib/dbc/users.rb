class Dbc::Users

  MUTABLE_ATTRIBUTES = [
    :name,
    :email,
    :password,
    :password_confirmation,
    :roles,
    :github_token,
  ]

  def initialize dbc
    @dbc = dbc
  end

  def all
    serialize Dbc::User.all
  end

  def create attributes={}
    sanatize_attributes(attributes)
    serialize Dbc::User.create!(attributes)
  end

  def show id
    serialize Dbc::User.find(id)
  end

  def update id, attributes={}
    sanatize_attributes(attributes)
    user = Dbc::User.find(id)
    user.update_attributes(attributes)
    serialize user
  end

  def destroy id
    user = Dbc::User.find(id)
    user.destroy
    serialize user
  end

  def sanatize_attributes(attributes)
    attributes.to_hash.symbolize_keys!.slice! *MUTABLE_ATTRIBUTES
  end

  def serializer
    @serializer ||= Dbc::User::Serializer.new(@dbc)
  end

  def serialize user_or_users
    if user_or_users.respond_to? :map
      user_or_users.map(&serializer)
    else
      serializer.serialize(user_or_users)
    end
  end

end
