module Abilities
  class ManagerHighwayAbility
    include CanCan::Ability

    def initialize(user)

      can :view_all, Inspection # allows for seeing everything and assigning to different teams

      can :update_from_structure, TransamAssetRecord

    end
  end
end