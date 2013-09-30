class Dbc::Ability
  # include CanCan::Ability

  def initialize(user_group)
    @user_group = user_group or
    raise ArgumentError, "user_group cannot be nil" if @user_group.nil?
    raise ArgumentError, "user_group must be a Dbc::UserGroup" unless @user_group.is_a? Dbc::UserGroup
  end

  attr_reader :user_group
  delegate :roles, :users, :user_ids, to: :user_group

  Dbc::User::Roles::ROLES.each do |role|
    define_method "#{role}?" do
      roles.include?(role)
    end
  end

  ACTIONS  = [:index, :create, :show, :update, :destroy]
  SUBJECTS = [:users, :user, :cohorts, :cohort]

  UnknownAction     = Class.new(ArgumentError)
  UnknownSubject    = Class.new(ArgumentError)
  MissingConditions = Class.new(ArgumentError)

  def can? action, subject, condition={}
    raise UnknownAction,  action  if  ACTIONS.exclude? action
    raise UnknownSubject, subject if SUBJECTS.exclude? subject

    return true if admin?

    case
    when admin?
      return true

    when student?, editor?

      case action

      when :index
        return true

      when :create
        return false


      when :show
        return true


      when :update

        case subject
        when :user
          condition[:id].present? or raise MissingConditions, ":id condition is missing"
          return user_ids.include?(condition[:id])
        end

        return false

      when :destroy
        return false

      end

    end
  end

  def cannot? *args
    !can?(*args)
  end

end
