#encoding: utf-8

# determine if we are using postgres or mysql
is_mysql = (ActiveRecord::Base.configurations[Rails.env]['adapter'].include?'mysql2')
is_sqlite =  (ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'sqlite3')

puts "======= Updating TransAM Highway Seed  ======="

organization_types = [
    {
        :active => 1, :name => 'Highway Authority', :class_name => "HighwayAuthority",
        :display_icon_name => "fa fa-highway", :map_icon_name => "redIcon",
        :description => 'Manage highway structures, bridges.'
    }
]

organization_types.each do |type|
  OrganizationType.create!(type)
end