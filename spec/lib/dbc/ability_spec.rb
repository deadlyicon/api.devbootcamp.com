require 'spec_helper'

describe Dbc::Ability do

  ROLES     = Dbc::User::Roles::ROLES
  ABILITIES = [:create, :read, :update, :destroy]
  MODELS    = [Dbc::User]

  ROLES.each do |role|
    let(role){
      user = Dbc::User.new(roles: [role]) if role
      user_group = Dbc::UserGroup.new(users: [user])
      user_group.ability
    }
  end

  it "should work" do

    # binding.pry

    assert student, :cannot, :create,  Dbc::User
    assert student, :can,    :read,    Dbc::User
    assert student, :cannot, :update,  Dbc::User
    assert student, :cannot, :destroy, Dbc::User
    assert editor,  :cannot, :create,  Dbc::User
    assert editor,  :can,    :read,    Dbc::User
    assert editor,  :cannot, :update,  Dbc::User
    assert editor,  :cannot, :destroy, Dbc::User
    assert admin,   :can,    :create,  Dbc::User
    assert admin,   :can,    :read,    Dbc::User
    assert admin,   :can,    :update,  Dbc::User


    # user = Dbc::User.student

  end

  def assert user_group, can, ability, object
    return if user_group.send("#{can}?", ability, object)
    raise RSpec::Expectations::ExpectationNotMetError, \
      "expected #{role} to be able to #{ability} #{Class === object ? object.name : object.inspect}"
  end

end
