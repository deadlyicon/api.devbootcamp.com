class Dbc::Users

  MUTABLE_ATTRIBUTES = [
    :name,
    :email,
    :password,
    :password_confirmation,
    :roles,
    :github_token,
  ]

  class Error < StandardError
    def initialize(user)
      @user = user
    end
    attr_reader :user
  end

  def initialize dbc
    @dbc = dbc
  end

  def all
    serialize Dbc::User.all
  end

  def create attributes={}
    sanatize_attributes(attributes)
    user = Dbc::User.create(attributes)
    serialize user
    # return serialized_user if user.persisted?
    # raise Error.new(serialized_user)
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
