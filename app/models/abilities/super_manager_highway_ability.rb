module Abilities
  class SuperManagerHighwayAbility
    include CanCan::Ability

    def initialize(user, organization_ids=[])

      if organization_ids.empty?
        organization_ids = user.organization_ids
      end

      can :update, [Inspection, BridgeCondition, CulvertCondition] do |inspection|
        inspection.updatable?
      end

      can :update_from_inspection, TransamAssetRecord
      can :update_from_structure, TransamAssetRecord

    end
  end
end