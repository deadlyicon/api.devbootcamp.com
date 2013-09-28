require 'spec_helper'

describe Dbc::Ability do

  ROLES     = Dbc::User::Roles::ROLES
  ABILITIES = [:create, :read, :update, :destroy]
  MODELS    = [Dbc::User]

  ROLES.each do |role|
    let(role){
      user = create_user_with_roles role
      Dbc::UserGroup.new(users: [user])
    }
  end

  it "should work" do

    # binding.pry

    student .cannot! :create,  Dbc::User
    student .can!    :read,    Dbc::User
    student .cannot! :update,  Dbc::User
    student .cannot! :destroy, Dbc::User
    editor  .cannot! :create,  Dbc::User
    editor  .can!    :read,    Dbc::User
    editor  .cannot! :update,  Dbc::User
    editor  .cannot! :destroy, Dbc::User
    admin   .can!    :create,  Dbc::User
    admin   .can!    :read,    Dbc::User
    admin   .can!    :update,  Dbc::User

    as_a :student do
      dbc.cannot! :create,  Dbc::User
      dbc.can!    :read,    Dbc::User
      dbc.cannot! :update,  Dbc::User
      dbc.cannot! :destroy, Dbc::User
    end

    as_a :editor do
      dbc.cannot! :create,  Dbc::User
      dbc.can!    :read,    Dbc::User
      dbc.cannot! :update,  Dbc::User
      dbc.cannot! :destroy, Dbc::User
    end

    as_an :admin do
      dbc.can!    :create,  Dbc::User
      dbc.can!    :read,    Dbc::User
      dbc.can!    :update,  Dbc::User
      dbc.can!    :destroy, Dbc::User
    end


    # user = Dbc::User.student

  end


end
