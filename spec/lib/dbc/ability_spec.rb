require 'spec_helper'

describe Dbc::Ability do

  ROLES     = Dbc::User::Roles::ROLES
  ABILITIES = [:create, :read, :update, :destroy]
  MODELS    = [Dbc::User]

  it "should work" do

    assert :student, :cannot, :create,  Dbc::User
    assert :student, :can,    :read,    Dbc::User
    assert :student, :cannot, :update,  Dbc::User
    assert :student, :cannot, :destroy, Dbc::User
    assert :editor,  :cannot, :create,  Dbc::User
    assert :editor,  :can,    :read,    Dbc::User
    assert :editor,  :cannot, :update,  Dbc::User
    assert :editor,  :cannot, :destroy, Dbc::User
    assert :admin,   :can,    :create,  Dbc::User
    assert :admin,   :can,    :read,    Dbc::User
    assert :admin,   :can,    :update,  Dbc::User
    assert :admin,   :can,    :destroy, Dbc::User

  end

  def assert user, can, ability, object
    role = user if user.is_a? Symbol
    user = Dbc::User.new(roles: [role]) if role
    user_group = Dbc::UserGroup.new(users: [user])

    return if user_group.send("#{can}?", ability, object)
    raise RSpec::Expectations::ExpectationNotMetError, \
      "expected #{role} to be able to #{ability} #{Class === object ? object.name : object.inspect}"
  end

end
