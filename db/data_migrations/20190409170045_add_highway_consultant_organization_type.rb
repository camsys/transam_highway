class AddHighwayConsultantOrganizationType < ActiveRecord::DataMigration
  def up
    if OrganizationType.find_by(name: 'Highway Consultant')
      OrganizationType.find_by(name: 'Highway Consultant').update!(class_name: 'HighwayConsultant')
    else
      OrganizationType.create!(name: "Highway Consultant",
                               class_name: "HighwayConsultant",
                               display_icon_name: "fa fa-user-circle",
                               map_icon_name: "purpleIcon",
                               description: "Consultant on highway structures, bridges.",
                               roles: nil,
                               active: true)
    end
  end
end