class RemoveHighwayTeams < ActiveRecord::DataMigration
  def up

    teams = Organization.where(organization_type: OrganizationType.where(class_name: 'HighwayTeam'))

    Inspection.where(assigned_organization_id: teams.pluck(:id)).update_all(assigned_organization_id: Organization.find_by(organization_type: OrganizationType.find_by(class_name: 'HighwayAuthority')).id)

    teams.destroy_all

    OrganizationType.find_by(class_name: 'HighwayTeam').destroy
  end
end