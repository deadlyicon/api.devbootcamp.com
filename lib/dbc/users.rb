class Dbc::Users

  def initialize dbc
    @dbc = dbc
  end

  def all
    serialize Dbc::User.all
  end

  def create attributes={}
    serialize Dbc::User.create!(attributes)
  end

  def new attributes={}
    serialize Dbc::User.new(attributes)
  end

  def show id
    serialize Dbc::User.find(id)
  end

  def update id, attributes={}
    user = Dbc::User.find(id)
    user.update_attributes(attributes)
    serialize user
  end

  def destroy id
    user = Dbc::User.find(id)
    user.destroy
    serialize user
  end

  private

  def serialize x
    x.as_json
    # Dbc::User::Serializer[users]

  end


end
