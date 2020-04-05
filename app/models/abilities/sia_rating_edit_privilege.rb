module Abilities
  class SiaRatingEditPrivilege
    include CanCan::Ability

    def initialize(user, organization_ids=[])

      if organization_ids.empty?
        organization_ids = user.organization_ids
      end

      can [:update, :update_from_structure], TransamAssetRecord

      AssetType.pluck(:class_name).each do |class_name|
        class_name.constantize.new.rating_params.each do |field|
          can "update_#{field}".to_sym, class_name.constantize
        end
      end

    end
  end
end