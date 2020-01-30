module Abilities
  class Inspector
    include CanCan::Ability

    def initialize(user, organization_ids=[])

      if organization_ids.empty?
        organization_ids = user.organization_ids
      end

      can :update, [Inspection, BridgeCondition, CulvertCondition] do |inspection|
        (inspection.inspector_ids.include? user.id)
      end

    end
  end
end