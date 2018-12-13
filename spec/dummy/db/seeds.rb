TransamCore::Engine.load_seed

puts "======= Processing TransAM Spatial Lookup Tables  ======="
# determine if we are using postgres or mysql
is_mysql = (ActiveRecord::Base.configurations[Rails.env]['adapter'].include? 'mysql2')
is_sqlite =  (ActiveRecord::Base.configurations[Rails.env]['adapter'] == 'sqlite3')

#------------------------------------------------------------------------------
#
# Lookup Tables
#
# These are the lookup tables for TransAM Spatial
#
#------------------------------------------------------------------------------

location_reference_types = [
  #{:active => 1, :name => 'Well Known Text',        :format => "WELL_KNOWN_TEXT", :description => 'Location is determined by a well known text (WKT) string.'},
  #{:active => 1, :name => 'Route/Milepost/Offset',  :format => "LRS",             :description => 'Location is determined by a route milepost and offset.'},
  {:active => 1, :name => 'Street Address',         :format => "ADDRESS",         :description => 'Location is determined by a geocoded street address.'},
  {:active => 1, :name => 'Map Location',           :format => "COORDINATE",      :description => 'Location is determined by deriving a location from a map.'},
  {:active => 1, :name => 'Derived',                :format => "DERIVED",         :description => 'Location is determined by deriving a location from releated spatial objects.'},
  #{:active => 1, :name => 'GeoServer',              :format => "GEOSERVER",       :description => 'Location is determined by deriving a location from Geo Server.'},
  {:active => 1, :name => 'Undefined',              :format => "NULL",            :description => 'Location is not defined.'}
]

lookup_tables = %w{ location_reference_types }

lookup_tables.each do |table_name|
  puts "  Loading #{table_name}"
  if is_mysql
    ActiveRecord::Base.connection.execute("TRUNCATE TABLE #{table_name};")
  elsif is_sqlite
    ActiveRecord::Base.connection.execute("DELETE FROM #{table_name};")
  else
    ActiveRecord::Base.connection.execute("TRUNCATE #{table_name} RESTART IDENTITY;")
  end
  data = eval(table_name)
  klass = table_name.classify.constantize
  data.each do |row|
    x = klass.new(row)
    x.save!
  end
end

puts "======= Adding Highway Engine specifics  ======="

puts "  Adding spatial extension"
SystemConfigExtension.find_or_create_by(class_name: 'HighwayStructure', extension_name: "TransamCoordinateLocatable", active: true)

puts "  Processing system_config"
SystemConfig.find_or_create_by(:customer_id => 1,
  :start_of_fiscal_year => '07-01',
  :map_tile_provider => 'GOOGLEMAP',
  :srid => 3857,
  :min_lat => 39.721712,
  :min_lon => -80.518166,
  :max_lat => 42.049293,
  :max_lon => -74.70746,
  :search_radius => 300,
  :search_units => 'ft',
  :geocoder_components => 'administrative_area:PA|country:US',
  :geocoder_region => 'us',
  :num_forecasting_years => 12,
  :num_reporting_years => 20,
  :max_rows_returned => 500,
  :data_file_path => '/data/'
)

puts "  processing System User"
User.find_or_create_by(
  :id => 1,
  :first_name => "system",
  :last_name => "user",
  :phone => "617-123-4567",
  :timezone => "Eastern Time (US & Canada)",
  :email => "admin@email.com",
  :num_table_rows => 10,
  )