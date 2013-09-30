class Dbc::UserGroups::Serializer < Dbc::Serializer

  def serialize user_group

    # Permissions will go in here

    users = user_group.users.map do |user|
      dbc.users.serialize(user)
    end

    data = {
      "id"           => user_group.id,
      "roles"        => user_group.roles,
      "users"        => users,
    }

    data["errors"] = user_group.errors.full_messages if user_group.errors.present?

    return data

  end

end
