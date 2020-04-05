module Abilities
  class ScourCriticalEditPrivilege
    include CanCan::Ability

    def initialize(user, organization_ids=[])

      if organization_ids.empty?
        organization_ids = user.organization_ids
      end

      can :update_scour_critical_bridge_type_id, InspectionRecord

    end
  end
end