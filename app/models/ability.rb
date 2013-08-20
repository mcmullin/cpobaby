class Ability
  include CanCan::Ability

  def initialize(user)
    if user.kind_of? Admin # .kind_of? is a stricter check than .is_a? e.g. dealing with inheritance
      can :manage, :all
      #cannot :create, Order
    elsif user.kind_of? Rep
      can :manage, Order, rep_id: user.id
      #can :create, Order
      #can :read, Order, rep_id: user.id
      #can :update, Order, rep_id: user.id
      #can :destroy, Order, rep_id: user.id

      can :index, Product

      #can :read, :all
    else
      #can :read, :all
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end

=begin

class AdminAbility
  include CanCan::Ability

  def initialize(admin)
    can :manage, :all
  end
end

class RepAbility
  include CanCan::Ability

  def initialize(rep)
    can :create, Order
    can :read, Order, rep_id: rep.id
    can :update, Order, rep_id: rep.id
    cannot :destroy, Order

    can :read, Product
  end
end

=end
