RSpec.configure do |config|

  DatabaseCleaner.strategy = :truncation, {:only => %w[transam_assets assets asset_events asset_event_asset_subsystems asset_groups asset_groups_assets asset_subsystems asset_subtypes asset_types defects defect_definitions elements element_definitions fuel_types highway_structures inspections maintenance_types messages notices policies policy_asset_type_rules policy_asset_subtype_rules organizations organization_types tasks users users_organizations user_organization_filters user_organization_filters_organizations users_roles weather_codes delayed_job_priorities inspection_type_settings bridge_like_conditions inspection_types]}
  # DatabaseCleaner.strategy = :transaction
  config.before(:suite) do
    begin
      DatabaseCleaner.start
    ensure
      DatabaseCleaner.clean
    end
  end
end
