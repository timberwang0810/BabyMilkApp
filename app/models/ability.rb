# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.role? :admin
      can :manage, :all
    elsif user.role? :nurse
      can :edit, Bottle
      can :update, Bottle
      can :destroy, Bottle
      can :create, Visit
    else
      can :read, :all
    end
  end
end
