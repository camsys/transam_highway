module Abilities
  class ManagerHighwayAbility
    include CanCan::Ability

    def initialize(user)

      ability = Abilities::SiaFullEditPrivilege.new(user, user.viewable_organization_ids) rescue nil
      self.merge ability if ability.present?

      can :view_all, Inspection # allows for seeing everything and assigning to different teams
      can :schedule, Inspection

    end
  end
end