Rails.application.config.geojson_properties = [
    :organization_id,
    :name,
    :asset_type,
    :reported_condition_type,
    :age,
    :description
]

# Specify the geometry adapter to use. One of "rgeo" or "georuby"
Rails.application.config.transam_spatial_geometry_adapter = "rgeo"
Rails.application.config.geocoding_service  = "GoogleGeocodingService"
Rails.application.config.map_min_zoom_level = 8
Rails.application.config.map_max_zoom_level = 18
Rails.application.config.rgeo_factory = RGeo::Geographic.spherical_factory(srid: 4326)
Rails.application.config.rgeo_proj4_srid = 4326


# Specify the mapping library to use. One of "leaflet", "mapbox"
#Rails.application.config.transam_spatial_map_options = "mapbox"
Rails.application.config.transam_spatial_map_control = "leaflet"

# Determine which controls will be used on the map
# Options include: "marker_cluster", "full_screen", "draw", "locate"
Rails.application.config.transam_spatial_map_options = ["map_page", "marker_cluster", "esri"]
