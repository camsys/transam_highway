module Abilities
  class ManagerHighwayAbility
    include CanCan::Ability

    def initialize(user)

      ability = Abilities::SiaFullEditPrivilege.new(user, user.viewable_organization_ids) rescue nil
      self.merge ability if ability.present?

      if user.organization.organization_type.class_name == 'HighwayAuthority'
        can :view_all, Inspection # allows for seeing everything and assigning to different teams
        can :switch_team, InspectionRecord
      else
        can :switch_team, InspectionRecord do |insp|
          user.viewable_organization_ids.reject{|o| o == HighwayAuthority.first.id}.include? insp.assigned_organization_id
        end
      end
      can :schedule, Inspection


      # user management
      cannot :authorize, Organization do |org|
        org.organization_type.class_name == 'HighwayAuthority' && user.organization.organization_type.class_name != 'HighwayAuthority'
      end
      if org.organization_type.class_name != 'HighwayAuthority'
        cannot [:update, :authorizations], User do |usr|
          !user.organizations.include?(usr.organization)
        end
      end
      can :assign, Role do |r|
        r.name != 'super_manager' && r.name != 'admin'
      end

    end
  end
end