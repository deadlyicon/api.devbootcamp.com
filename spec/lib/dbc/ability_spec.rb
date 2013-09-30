require 'spec_helper'

describe Dbc::Ability do

  ROLES = Dbc::User::Roles::ROLES

  ROLES.each do |role|
    let(role){ create_user_with_roles role }
  end

  let(:other_user){
    user_ids = ROLES.map{|r| send(r).id }
    Dbc::User.where('users.id NOT IN (?)', user_ids).first!
  }

  def assert_ability! users, can, ability, subject, conditions={}
    users = Array(users)
    user_group = Dbc::UserGroup.new(users: users)
    return if user_group.send("#{can}?", ability, subject, conditions)
    knot = can == :cannot
    raise "expected the users #{user_group.user_ids.inspect} "+
      "with the roles #{user_group.roles.inspect} to "+
      (knot ? 'not ' : '')+
      "be able to #{ability} #{subject.inspect} #{conditions.inspect}"
  end



  it "should work as expected" do

    assert_ability! student, :cannot, :create,  :users
    assert_ability! student, :can,    :show,    :user,  id: student.id
    assert_ability! student, :can,    :update,  :user,  id: student.id
    assert_ability! student, :cannot, :destroy, :user,  id: student.id

    assert_ability! student, :cannot, :create,  :users
    assert_ability! student, :can,    :show,    :user,  id: other_user.id
    assert_ability! student, :cannot, :update,  :user,  id: other_user.id
    assert_ability! student, :cannot, :destroy, :user,  id: other_user.id


    assert_ability! editor,  :cannot, :create,  :users
    assert_ability! editor,  :can,    :show,    :user,  id: editor.id
    assert_ability! editor,  :can,    :update,  :user,  id: editor.id
    assert_ability! editor,  :cannot, :destroy, :user,  id: editor.id

    assert_ability! editor,  :cannot, :create,  :users
    assert_ability! editor,  :can,    :show,    :user,  id: other_user.id
    assert_ability! editor,  :cannot, :update,  :user,  id: other_user.id
    assert_ability! editor,  :cannot, :destroy, :user,  id: other_user.id


    assert_ability! admin,   :can,    :create,  :users
    assert_ability! admin,   :can,    :show,    :user,  id: admin.id
    assert_ability! admin,   :can,    :update,  :user,  id: admin.id
    assert_ability! admin,   :can,    :destroy, :user,  id: admin.id

    assert_ability! admin,   :can,    :create,  :users
    assert_ability! admin,   :can,    :show,    :user,  id: other_user.id
    assert_ability! admin,   :can,    :update,  :user,  id: other_user.id
    assert_ability! admin,   :can,    :destroy, :user,  id: other_user.id



    # assert_ability! editor,  :cannot, :create,  :user
    # assert_ability! editor,  :can,    :show,    :user
    # assert_ability! editor,  :cannot, :update,  :user
    # assert_ability! editor,  :cannot, :destroy, :user
    # assert_ability! admin,   :can,    :create,  :user
    # assert_ability! admin,   :can,    :show,    :user
    # assert_ability! admin,   :can,    :update,  :user

    # # assert_ability! student, :cannot, :create,  :user
    # # assert_ability! student, :can,    :show,    :user
    # # assert_ability! student, :can,    :update,  :user
    # # assert_ability! student, :cannot, :destroy, :user
    # # assert_ability! editor,  :cannot, :create,  :user
    # # assert_ability! editor,  :can,    :show,    :user
    # # assert_ability! editor,  :can,    :update,  :user
    # # assert_ability! editor,  :cannot, :destroy, :user
    # # assert_ability! admin,   :can,    :create,  :user
    # # assert_ability! admin,   :can,    :show,    :user
    # # assert_ability! admin,   :can,    :update,  :user


    # assert_ability! student, :can,    :show,    student
    # assert_ability! student, :can,    :update,  student

    # assert_ability! editor,  :can,    :show,    student
    # assert_ability! editor,  :cannot, :update,  student

    # assert_ability! admin,   :can,    :show,    student
    # assert_ability! admin,   :can,    :update,  student


    # assert_ability! student, :can,    :show,    editor
    # assert_ability! student, :cannot, :update,  editor

    # assert_ability! editor,  :can,    :show,    editor
    # assert_ability! editor,  :can,    :update,  editor

    # assert_ability! admin,   :can,    :show,    editor
    # assert_ability! admin,   :can,    :update,  editor


    # assert_ability! student, :can,    :show,    admin
    # assert_ability! student, :cannot, :update,  admin

    # assert_ability! editor,  :can,    :show,    admin
    # assert_ability! editor,  :cannot, :update,  admin

    # assert_ability! admin,   :can,    :show,    admin
    # assert_ability! admin,   :can,    :update,  admin


    # assert_ability! [student,editor], :can, :show,   student
    # assert_ability! [student,editor], :can, :update, student

  end


end
