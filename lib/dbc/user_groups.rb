class Dbc::UserGroups

  include Dbc::Dependant

  def show id
    serialize Dbc::UserGroup.find(id)
  end

  def serializer
    @serializer ||= Serializer.new(@dbc)
  end

  def serialize user_group_or_user_groups
    if user_group_or_user_groups.respond_to? :map
      user_group_or_user_groups.map(&serializer)
    else
      serializer.serialize(user_group_or_user_groups)
    end
  end

end
