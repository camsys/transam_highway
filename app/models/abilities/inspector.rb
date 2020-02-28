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

      can :update, TransamAssetRecord

      AssetType.pluck(:class_name).each do |class_name|
        class_name.constantize.new.unallowable_inspector_params.each do |field|
          cannot "update_#{field}".to_sym, class_name.constantize
        end
      end

    end
  end
end