class Dbc::Users::Serializer < Dbc::Serializer

  def serialize user

    # Permissions will go in here

    data = {
      "id"           => user.id,
      "name"         => user.name,
      "email"        => user.email,
      "roles"        => user.roles,
      "github_token" => user.github_token,
      "created_at"   => user.created_at,
      "updated_at"   => user.updated_at,
    }

    data["errors"] = user.errors.full_messages if user.errors.present?

    return data

  end

end
