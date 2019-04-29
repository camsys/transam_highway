module Abilities
  class Inspector
    include CanCan::Ability

    def initialize(user, organization_ids=[])

      if organization_ids.empty?
        organization_ids = user.organization_ids
      end

      can :update, Inspection do |inspection|
        (inspection.inspector_ids.include? user.id) && (['in_progress', 'draft_report', 'qc_review'].include? inspection.state)
      end

    end
  end
end