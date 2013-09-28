class Dbc::User::Serializer

  def initialize dbc
    @dbc = dbc
  end

  def to_proc
    method(:call).to_proc
  end

  def call user

    # Permissions will go in here

    return {
      "id"           => user.id,
      "name"         => user.name,
      "email"        => user.email,
      "roles"        => user.roles.join(' '),
      "github_token" => user.github_token,
      "created_at"   => user.created_at,
      "updated_at"   => user.updated_at,
    }

  end

end
