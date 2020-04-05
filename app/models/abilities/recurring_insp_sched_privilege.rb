module Abilities
  class RecurringInspSchedPrivilege
    include CanCan::Ability

    def initialize(user, organization_ids=[])

      if organization_ids.empty?
        organization_ids = user.organization_ids
      end

      can :schedule, Inspection
    end
  end
end