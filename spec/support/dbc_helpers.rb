module DbcHelpers

  extend ActiveSupport::Concern

  def create_user_with_roles *roles
    create('dbc/user', :roles => roles)
  end

  # become :student
  # become :student, :admin
  # become user1, user2
  # become user_group
  # become user_group, user
  # become user_group, user, :admin
  def become *objects
    user_ids = objects.map do |object|
      next object.id                         if object.is_a? Dbc::User
      next object.user_ids                   if object.is_a? Dbc::UserGroup
      next create_user_with_roles(object).id if object.is_a? Symbol
      raise ArgumentError, "unexpected object #{object.inspect}"
    end
    stub_current_user_ids(user_ids)
  end

  def stub_current_user_ids current_user_ids
    @dbc = Dbc.new as: current_user_ids
    ApplicationController.any_instance.stub(:current_user_ids).and_return(current_user_ids)
  end

  def current_users
    dbc.current_user_group.users
  end

  def as *users, &block
    original_user_ids = dbc.current_user_group.user_ids if dbc
    become *users
    yield
  ensure
    stub_current_user_ids(original_user_ids) if original_user_ids
  end
  alias_method :as_an, :as
  alias_method :as_a, :as

  attr_reader :dbc

  module ClassMethods


    # as_a :student do
    #   …
    # end
    #
    # as_an :admin do
    #   …
    # end
    #
    def as_a *roles, &block
      context "as a user_group with the roles: #{roles.inspect}" do
        before{ become *roles }
        class_eval(&block)
      end
    end
    alias_method :as_an, :as_a

  end

end
