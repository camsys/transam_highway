class AddHighwayTeamOrganizationType < ActiveRecord::DataMigration
  def up
    OrganizationType.create!({
                                 name: "Highway Team",
                                 class_name: "HighwayTeam",
                                 display_icon_name: "fa fa-users",
                                 map_icon_name: "blueIcon",
                                 description: "Team for highway authority.",
                                 roles: nil,
                                 active: true
                             })

    OrganizationType.find_by(class_name: 'HighwayAuthority').update!(roles: 'manager,inspector')
    OrganizationType.where.not(class_name: 'HighwayAuthority').update_all(roles: 'inspector')

    Organization.includes(:organization_type).where(organization_types: {class_name: 'HighwayAuthority'}).each{|x| OrganizationRoleMapping.create!(organization_id: x.id, role_id: Role.find_by(name: 'manager').id)}
    Organization.all.each{|x| OrganizationRoleMapping.create!(organization_id: x.id, role_id: Role.find_by(name: 'inspector').id)}
  end
end