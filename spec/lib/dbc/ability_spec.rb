require 'spec_helper'

describe Dbc::Ability do

  ROLES     = Dbc::User::Roles::ROLES
  ABILITIES = [:create, :read, :update, :destroy]
  MODELS    = [Dbc::User]

  ROLES.each do |role|
    let(role){ create_user_with_roles role }
  end

  def assert_ability! users, can, ability, subject
    users = Array(users)
    user_group = Dbc::UserGroup.new(users: users)
    return if user_group.send("#{can}?", ability, subject)
    knot = can == :cannot
    raise "expected the users #{user_group.user_ids.inspect} "+
      "with the roles #{user_group.roles.inspect} to "+
      (knot ? 'not ' : '')+
      "be able to #{ability} #{subject.inspect}"
  end

  it "should work as expected" do

    assert_ability! student, :cannot, :create,  Dbc::User
    assert_ability! student, :can,    :read,    Dbc::User
    assert_ability! student, :can,    :update,  Dbc::User
    assert_ability! student, :cannot, :destroy, Dbc::User
    assert_ability! editor,  :cannot, :create,  Dbc::User
    assert_ability! editor,  :can,    :read,    Dbc::User
    assert_ability! editor,  :can,    :update,  Dbc::User
    assert_ability! editor,  :cannot, :destroy, Dbc::User
    assert_ability! admin,   :can,    :create,  Dbc::User
    assert_ability! admin,   :can,    :read,    Dbc::User
    assert_ability! admin,   :can,    :update,  Dbc::User


    assert_ability! student, :can,    :read,    student
    assert_ability! student, :can,    :update,  student

    assert_ability! editor,  :can,    :read,    student
    assert_ability! editor,  :cannot, :update,  student

    assert_ability! admin,   :can,    :read,    student
    assert_ability! admin,   :can,    :update,  student


    assert_ability! student, :can,    :read,    editor
    assert_ability! student, :cannot, :update,  editor

    assert_ability! editor,  :can,    :read,    editor
    assert_ability! editor,  :can,    :update,  editor

    assert_ability! admin,   :can,    :read,    editor
    assert_ability! admin,   :can,    :update,  editor


    assert_ability! student, :can,    :read,    admin
    assert_ability! student, :cannot, :update,  admin

    assert_ability! editor,  :can,    :read,    admin
    assert_ability! editor,  :cannot, :update,  admin

    assert_ability! admin,   :can,    :read,    admin
    assert_ability! admin,   :can,    :update,  admin


    assert_ability! [student,editor], :can, :read,   student
    assert_ability! [student,editor], :can, :update, student

  end


end
