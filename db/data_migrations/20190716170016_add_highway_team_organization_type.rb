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
  end
end