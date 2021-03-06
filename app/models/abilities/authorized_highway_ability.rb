module Abilities
  class AuthorizedHighwayAbility
    include CanCan::Ability

    def initialize(user, organization_ids=[])

      if organization_ids.empty?
        organization_ids = user.organization_ids
      end

      ability = Abilities::MaintenanceMgmtPrivilege.new(user, user.viewable_organization_ids) rescue nil
      self.merge ability if ability.present?

      can [:create, :audit, :destroy], InspectionRecord
      can :update, InspectionRecord do |inspection|
        (inspection.inspector_ids.include? user.id)
      end

      can :update, TransamAssetRecord
      can :manage, StreambedProfile
      can :manage, Roadway

      can :create, Document
      cannot [:update, :destroy], Document

      AssetType.pluck(:class_name).each do |class_name|
        class_name.constantize.new.inspector_params.each do |field|
          can "update_#{field}".to_sym, class_name.constantize
        end
      end

    end
  end
end