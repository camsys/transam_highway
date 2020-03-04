class RemoveHighwayTeams < ActiveRecord::DataMigration
  def up
    Inspection.where(assigned_organization_id: HighwayTeam.all.pluck(:id)).update_all(assigned_organization_id: Organization.find_by(organization_type: OrganizationType.find_by(class_name: 'HighwayAuthority')).id)

    HighwayTeam.all.destroy_all

    OrganizationType.find_by(class_name: 'HighwayTeam')
  end
end