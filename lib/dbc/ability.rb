class Dbc::Ability
  include CanCan::Ability

  def initialize(user_group)

    if user_group.admin?
      can :manage, :all
    else
      can :read, :all
    end


  end
end
