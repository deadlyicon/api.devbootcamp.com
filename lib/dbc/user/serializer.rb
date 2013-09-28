class Dbc::User::Serializer < Dbc::Serializer

  def serialize user

    # Permissions will go in here

    return {
      "id"           => user.id,
      "name"         => user.name,
      "email"        => user.email,
      "roles"        => user.roles,
      "github_token" => user.github_token,
      "created_at"   => user.created_at,
      "updated_at"   => user.updated_at,
    }

  end

end
