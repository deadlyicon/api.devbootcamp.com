class Dbc::Ability
  include CanCan::Ability

  def initialize(user_group)

    if user_group.admin?
      can :manage, :all
    else
      can :read, :all
      can :update, Dbc::User, :id => user_group.user_ids
    end


  end
end
