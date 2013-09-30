class Dbc::Users

  include Dbc::Dependant

  MUTABLE_ATTRIBUTES = [
    :name,
    :email,
    :password,
    :password_confirmation,
    :roles,
    :github_token,
  ]

  def all
    can! :index, :users
    serialize Dbc::User.all
  end

  def create attributes={}
    can! :create, :users
    sanatize_attributes(attributes)
    user = Dbc::User.create(attributes)
    return serialize(user) if user.errors.empty?
    raise Dbc::ValidationError, serialize(user)
  end

  def show id
    can! :show, :user, id: id
    user = Dbc::User.find(id)
    serialize user
  end

  def update id, attributes={}
    can! :update, :user, id: id

    sanatize_attributes(attributes)
    user = Dbc::User.find(id)
    user.update_attributes(attributes)
    return serialize(user) if user.errors.empty?
    raise Dbc::ValidationError, serialize(user)
  end

  def destroy id
    can! :destroy, :user, id: id
    user = Dbc::User.find(id)
    user.destroy
    serialize user
  end

  def sanatize_attributes(attributes)
    attributes.to_hash.symbolize_keys!.slice! *MUTABLE_ATTRIBUTES
  end

  def serializer
    @serializer ||= Serializer.new(@dbc)
  end

  def serialize user_or_users
    if user_or_users.respond_to? :map
      user_or_users.map(&serializer)
    else
      serializer.serialize(user_or_users)
    end
  end

end
