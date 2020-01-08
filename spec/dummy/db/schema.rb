# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_01_02_211300) do

  create_table "activities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12
    t.integer "organization_type_id"
    t.string "name", limit: 64
    t.text "description"
    t.boolean "show_in_dashboard"
    t.boolean "system_activity"
    t.date "start_date"
    t.date "end_date"
    t.integer "frequency_quantity", null: false
    t.integer "frequency_type_id", null: false
    t.string "execution_time", limit: 32, null: false
    t.string "job_name", limit: 64
    t.datetime "last_run"
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "activity_logs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.string "item_type", limit: 64, null: false
    t.integer "item_id"
    t.integer "user_id", null: false
    t.text "activity", limit: 4294967295, null: false
    t.datetime "activity_time"
    t.index ["organization_id", "activity_time"], name: "activity_logs_idx1"
    t.index ["user_id", "activity_time"], name: "activity_logs_idx2"
  end

  create_table "ancillary_condition_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "archived_fiscal_years", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "fy_year"
    t.index ["organization_id"], name: "index_archived_fiscal_years_on_organization_id"
  end

  create_table "assembly_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "assembly_types_asset_types", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "assembly_type_id", null: false
    t.bigint "asset_type_id", null: false
  end

  create_table "asset_event_asset_subsystems", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "asset_event_id"
    t.integer "asset_subsystem_id"
    t.integer "parts_cost"
    t.integer "labor_cost"
    t.index ["asset_event_id"], name: "rehab_events_subsystems_idx1"
    t.index ["asset_subsystem_id"], name: "rehab_events_subsystems_idx2"
  end

  create_table "asset_event_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "class_name", limit: 64, null: false
    t.string "job_name", limit: 64, null: false
    t.string "display_icon_name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
    t.index ["class_name"], name: "asset_event_types_idx1"
  end

  create_table "asset_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "asset_id"
    t.string "transam_asset_type"
    t.integer "transam_asset_id"
    t.bigint "base_transam_asset_id"
    t.integer "asset_event_type_id", null: false
    t.integer "upload_id"
    t.date "event_date", null: false
    t.decimal "assessed_rating", precision: 9, scale: 2
    t.integer "condition_type_id"
    t.integer "current_mileage"
    t.integer "parent_id"
    t.integer "replacement_year"
    t.integer "rebuild_year"
    t.integer "disposition_year"
    t.integer "extended_useful_life_miles"
    t.integer "extended_useful_life_months"
    t.integer "replacement_reason_type_id"
    t.string "replacement_status_type_id"
    t.date "disposition_date"
    t.integer "disposition_type_id"
    t.integer "service_status_type_id"
    t.integer "maintenance_type_id"
    t.integer "pcnt_5311_routes"
    t.integer "avg_daily_use_hours"
    t.integer "avg_daily_use_miles"
    t.integer "avg_daily_passenger_trips"
    t.decimal "avg_cost_per_mile", precision: 9, scale: 2
    t.decimal "avg_miles_per_gallon", precision: 9, scale: 2
    t.integer "annual_maintenance_cost"
    t.integer "annual_insurance_cost"
    t.boolean "actual_costs"
    t.integer "annual_affected_ridership"
    t.integer "annual_dollars_generated"
    t.integer "sales_proceeds"
    t.string "organization_id"
    t.text "comments"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "state", limit: 32
    t.string "document", limit: 128
    t.string "original_filename", limit: 128
    t.integer "created_by_id"
    t.bigint "updated_by_id"
    t.integer "total_cost"
    t.index ["asset_event_type_id"], name: "asset_events_idx3"
    t.index ["asset_id"], name: "asset_events_idx2"
    t.index ["base_transam_asset_id"], name: "index_asset_events_on_base_transam_asset_id"
    t.index ["created_by_id"], name: "asset_events_creator_idx"
    t.index ["event_date"], name: "asset_events_idx4"
    t.index ["object_key"], name: "asset_events_idx1"
    t.index ["updated_by_id"], name: "index_asset_events_on_updated_by_id"
    t.index ["upload_id"], name: "asset_events_idx5"
  end

  create_table "asset_groups", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "organization_id", null: false
    t.string "name", limit: 64, null: false
    t.string "code", limit: 8, null: false
    t.string "description", limit: 254
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["object_key"], name: "asset_groups_idx1"
    t.index ["organization_id"], name: "asset_groups_idx2"
  end

  create_table "asset_groups_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "asset_id"
    t.integer "transam_asset_id"
    t.integer "asset_group_id", null: false
    t.index ["asset_id", "asset_group_id"], name: "asset_groups_assets_idx1"
  end

  create_table "asset_subsystems", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64
    t.string "code", limit: 2
    t.string "description", limit: 254
    t.integer "asset_type_id"
    t.boolean "active"
  end

  create_table "asset_subtypes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "asset_type_id", null: false
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.string "image", limit: 254
    t.boolean "active", null: false
    t.index ["asset_type_id"], name: "asset_subtypes_idx1"
  end

  create_table "asset_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "asset_id"
    t.integer "user_id"
    t.index ["asset_id"], name: "asset_tags_idx1"
    t.index ["user_id"], name: "asset_tags_idx2"
  end

  create_table "asset_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "class_name", limit: 64, null: false
    t.string "display_icon_name", limit: 64, null: false
    t.string "map_icon_name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "allow_parent"
    t.boolean "active", null: false
    t.index ["class_name"], name: "asset_types_idx1"
    t.index ["name"], name: "asset_types_idx2"
  end

  create_table "asset_types_manufacturers", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "asset_type_id"
    t.integer "manufacturer_id"
    t.index ["asset_type_id", "manufacturer_id"], name: "asset_types_manufacturers_idx1"
  end

  create_table "assets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "organization_id", null: false
    t.integer "asset_type_id", null: false
    t.integer "asset_subtype_id", null: false
    t.string "asset_tag", limit: 32, null: false
    t.string "external_id", limit: 32
    t.integer "parent_id"
    t.integer "superseded_by_id"
    t.integer "manufacturer_id"
    t.string "other_manufacturer"
    t.string "manufacturer_model", limit: 128
    t.integer "manufacture_year"
    t.integer "pcnt_capital_responsibility"
    t.integer "vendor_id"
    t.integer "policy_replacement_year"
    t.integer "policy_rehabilitation_year"
    t.integer "estimated_replacement_year"
    t.integer "estimated_replacement_cost"
    t.integer "scheduled_replacement_year"
    t.integer "scheduled_rehabilitation_year"
    t.integer "scheduled_disposition_year"
    t.integer "scheduled_replacement_cost"
    t.text "early_replacement_reason"
    t.boolean "scheduled_replace_with_new"
    t.integer "scheduled_rehabilitation_cost"
    t.integer "replacement_reason_type_id"
    t.string "replacement_status_type_id"
    t.boolean "in_backlog"
    t.integer "reported_condition_type_id"
    t.decimal "reported_condition_rating", precision: 10, scale: 1
    t.integer "reported_mileage"
    t.date "reported_mileage_date"
    t.date "reported_condition_date"
    t.integer "estimated_condition_type_id"
    t.decimal "estimated_condition_rating", precision: 9, scale: 2
    t.integer "service_status_type_id"
    t.date "service_status_date"
    t.date "last_maintenance_date"
    t.boolean "depreciable"
    t.integer "book_value"
    t.integer "salvage_value"
    t.date "disposition_date"
    t.integer "disposition_type_id"
    t.date "last_rehabilitation_date"
    t.string "location_reference", limit: 254
    t.text "location_comments"
    t.integer "fuel_type_id"
    t.integer "vehicle_length"
    t.integer "gross_vehicle_weight"
    t.string "title_number", limit: 32
    t.string "serial_number", limit: 32
    t.boolean "purchased_new"
    t.integer "purchase_cost"
    t.date "purchase_date"
    t.date "warranty_date"
    t.date "in_service_date"
    t.integer "expected_useful_life"
    t.integer "expected_useful_miles"
    t.integer "rebuild_year"
    t.string "license_plate", limit: 32
    t.integer "seating_capacity"
    t.integer "standing_capacity"
    t.integer "wheelchair_capacity"
    t.integer "fta_ownership_type_id"
    t.integer "fta_vehicle_type_id"
    t.integer "fta_funding_type_id"
    t.boolean "ada_accessible_lift"
    t.boolean "ada_accessible_ramp"
    t.boolean "fta_emergency_contingency_fleet"
    t.string "description", limit: 128
    t.string "address1", limit: 128
    t.string "address2", limit: 128
    t.string "city", limit: 64
    t.string "state", limit: 2
    t.string "zip", limit: 10
    t.integer "facility_size"
    t.boolean "section_of_larger_facility"
    t.integer "pcnt_operational"
    t.integer "num_floors"
    t.integer "num_structures"
    t.integer "num_elevators"
    t.integer "num_escalators"
    t.integer "num_parking_spaces_public"
    t.integer "num_parking_spaces_private"
    t.decimal "lot_size", precision: 9, scale: 2
    t.string "line_number", limit: 128
    t.integer "quantity"
    t.string "quantity_units", limit: 16
    t.integer "created_by_id"
    t.integer "weight"
    t.integer "updated_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "upload_id"
    t.integer "location_id"
    t.integer "dual_fuel_type_id"
    t.index ["asset_subtype_id"], name: "assets_idx4"
    t.index ["asset_type_id"], name: "assets_idx3"
    t.index ["estimated_replacement_year"], name: "assets_idx8"
    t.index ["in_backlog"], name: "assets_idx7"
    t.index ["manufacture_year"], name: "assets_idx5"
    t.index ["object_key"], name: "assets_idx1"
    t.index ["organization_id", "asset_subtype_id", "in_backlog"], name: "assets_idx12"
    t.index ["organization_id", "asset_subtype_id", "policy_replacement_year"], name: "assets_idx10"
    t.index ["organization_id", "in_backlog"], name: "assets_idx11"
    t.index ["organization_id", "policy_replacement_year"], name: "assets_idx9"
    t.index ["organization_id"], name: "assets_idx2"
    t.index ["reported_condition_type_id"], name: "assets_idx6"
    t.index ["superseded_by_id"], name: "assets_idx13"
  end

  create_table "bridge_appraisal_rating_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "bridge_condition_rating_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "bridge_like_conditions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "deck_condition_rating_type_id"
    t.bigint "superstructure_condition_rating_type_id"
    t.bigint "substructure_condition_rating_type_id"
    t.bigint "structural_appraisal_rating_type_id"
    t.bigint "deck_geometry_appraisal_rating_type_id"
    t.bigint "underclearance_appraisal_rating_type_id"
    t.bigint "waterway_appraisal_rating_type_id"
    t.bigint "approach_alignment_appraisal_rating_type_id"
    t.bigint "operational_status_type_id"
    t.bigint "channel_condition_type_id"
    t.bigint "scour_critical_bridge_type_id"
    t.bigint "railings_safety_type_id"
    t.bigint "transitions_safety_type_id"
    t.bigint "approach_rail_safety_type_id"
    t.bigint "approach_rail_end_safety_type_id"
    t.bigint "culvert_condition_type_id"
    t.bigint "ancillary_condition_type_id"
    t.index ["ancillary_condition_type_id"], name: "index_bridge_like_conditions_on_ancillary_condition_type_id"
    t.index ["culvert_condition_type_id"], name: "index_bridge_like_conditions_on_culvert_condition_type_id"
  end

  create_table "bridge_likes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "main_span_material_type_id"
    t.bigint "main_span_design_construction_type_id"
    t.bigint "approach_spans_material_type_id"
    t.bigint "approach_spans_design_construction_type_id"
    t.integer "num_spans_main"
    t.integer "num_spans_approach"
    t.string "border_bridge_state"
    t.integer "border_bridge_pcnt_responsibility"
    t.string "border_bridge_structure_number"
    t.bigint "strahnet_designation_type_id"
    t.bigint "deck_structure_type_id"
    t.bigint "wearing_surface_type_id"
    t.bigint "membrane_type_id"
    t.bigint "deck_protection_type_id"
    t.bigint "service_on_type_id"
    t.bigint "service_under_type_id"
    t.bigint "bridge_toll_type_id"
    t.bigint "design_load_type_id"
    t.bigint "operating_rating_method_type_id"
    t.decimal "operating_rating", precision: 9, scale: 2
    t.bigint "inventory_rating_method_type_id"
    t.decimal "inventory_rating", precision: 9, scale: 2
    t.bigint "bridge_posting_type_id"
    t.decimal "max_span_length", precision: 9, scale: 2
    t.decimal "left_curb_sidewalk_width", precision: 9, scale: 2
    t.decimal "right_curb_sidewalk_width", precision: 9, scale: 2
    t.decimal "roadway_width", precision: 9, scale: 2
    t.decimal "deck_width", precision: 9, scale: 2
    t.decimal "min_vertical_clearance_above", precision: 9, scale: 2
    t.bigint "vertical_reference_feature_below_id"
    t.decimal "min_vertical_clearance_below", precision: 9, scale: 2
    t.bigint "lateral_reference_feature_below_id"
    t.decimal "min_lateral_clearance_below_right", precision: 9, scale: 2
    t.decimal "min_lateral_clearance_below_left", precision: 9, scale: 2
    t.string "maintenance_patrol"
    t.bigint "mast_arm_frame_type_id"
    t.bigint "column_type_id"
    t.bigint "foundation_type_id"
    t.bigint "upper_connection_type_id"
    t.index ["approach_spans_design_construction_type_id"], name: "idx_bridge_likes_on_approach_spans_design_construction_type_id"
    t.index ["approach_spans_material_type_id"], name: "index_bridge_likes_on_approach_spans_material_type_id"
    t.index ["bridge_posting_type_id"], name: "index_bridge_likes_on_bridge_posting_type_id"
    t.index ["bridge_toll_type_id"], name: "index_bridge_likes_on_bridge_toll_type_id"
    t.index ["column_type_id"], name: "index_bridge_likes_on_column_type_id"
    t.index ["deck_protection_type_id"], name: "index_bridge_likes_on_deck_protection_type_id"
    t.index ["deck_structure_type_id"], name: "index_bridge_likes_on_deck_structure_type_id"
    t.index ["design_load_type_id"], name: "index_bridge_likes_on_design_load_type_id"
    t.index ["foundation_type_id"], name: "index_bridge_likes_on_foundation_type_id"
    t.index ["inventory_rating_method_type_id"], name: "index_bridge_likes_on_inventory_rating_method_type_id"
    t.index ["lateral_reference_feature_below_id"], name: "index_bridge_likes_on_lateral_reference_feature_below_id"
    t.index ["main_span_design_construction_type_id"], name: "index_bridge_likes_on_main_span_design_construction_type_id"
    t.index ["main_span_material_type_id"], name: "index_bridge_likes_on_main_span_material_type_id"
    t.index ["mast_arm_frame_type_id"], name: "index_bridge_likes_on_mast_arm_frame_type_id"
    t.index ["membrane_type_id"], name: "index_bridge_likes_on_membrane_type_id"
    t.index ["operating_rating_method_type_id"], name: "index_bridge_likes_on_operating_rating_method_type_id"
    t.index ["service_on_type_id"], name: "index_bridge_likes_on_service_on_type_id"
    t.index ["service_under_type_id"], name: "index_bridge_likes_on_service_under_type_id"
    t.index ["strahnet_designation_type_id"], name: "index_bridge_likes_on_strahnet_designation_type_id"
    t.index ["upper_connection_type_id"], name: "index_bridge_likes_on_upper_connection_type_id"
    t.index ["vertical_reference_feature_below_id"], name: "index_bridge_likes_on_vertical_reference_feature_below_id"
    t.index ["wearing_surface_type_id"], name: "index_bridge_likes_on_wearing_surface_type_id"
  end

  create_table "bridge_posting_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "bridge_toll_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "channel_condition_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "column_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "commentable_id", null: false
    t.string "commentable_type", limit: 64, null: false
    t.string "comment", limit: 254, null: false
    t.integer "created_by_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["commentable_id", "commentable_type"], name: "comments_idx1"
  end

  create_table "condition_estimation_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "class_name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
    t.index ["class_name"], name: "condition_estimation_types_idx1"
  end

  create_table "condition_rollup_calculation_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "class_name"
    t.string "description"
    t.boolean "active"
  end

  create_table "condition_type_percents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "asset_event_id"
    t.integer "condition_type_id"
    t.integer "pcnt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["asset_event_id"], name: "index_condition_type_percents_on_asset_event_id"
    t.index ["condition_type_id"], name: "index_condition_type_percents_on_condition_type_id"
  end

  create_table "condition_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.decimal "rating_ceiling", precision: 9, scale: 2, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
  end

  create_table "cost_calculation_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "class_name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
    t.index ["class_name"], name: "cost_calculation_types_idx1"
  end

  create_table "culvert_condition_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "customers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "license_type_id", null: false
    t.string "name", limit: 64, null: false
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "deck_protection_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "deck_structure_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "defect_definitions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "number"
    t.string "long_name"
    t.string "short_name"
    t.string "description"
    t.string "condition_state_1_def"
    t.string "condition_state_2_def"
    t.string "condition_state_3_def"
    t.string "condition_state_4_def"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["number"], name: "index_defect_definitions_on_number"
  end

  create_table "defect_definitions_element_definitions", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "defect_definition_id", null: false
    t.bigint "element_definition_id", null: false
    t.index ["element_definition_id", "defect_definition_id"], name: "idx_defect_defintions_element_definitions"
  end

  create_table "defect_locations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key"
    t.string "guid", limit: 36
    t.bigint "defect_id"
    t.float "quantity"
    t.string "location_description"
    t.integer "location_distance"
    t.string "condition_state"
    t.string "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["defect_id"], name: "index_defect_locations_on_defect_id"
  end

  create_table "defects", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "guid", limit: 36
    t.bigint "element_id"
    t.bigint "defect_definition_id"
    t.bigint "inspection_id"
    t.float "condition_state_1_quantity"
    t.float "condition_state_2_quantity"
    t.float "condition_state_3_quantity"
    t.float "condition_state_4_quantity"
    t.float "total_quantity"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["defect_definition_id"], name: "index_defects_on_defect_definition_id"
    t.index ["element_id"], name: "index_defects_on_element_id"
    t.index ["guid"], name: "index_defects_on_guid"
    t.index ["inspection_id"], name: "index_defects_on_inspection_id"
    t.index ["object_key"], name: "index_defects_on_object_key"
  end

  create_table "delayed_job_priorities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "class_name", null: false
    t.integer "priority", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "delayed_jobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "priority"
    t.integer "attempts"
    t.text "handler"
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "design_construction_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "asset_subtype_id"
    t.string "name"
    t.string "code"
    t.boolean "active"
    t.index ["asset_subtype_id"], name: "index_design_construction_types_on_asset_subtype_id"
  end

  create_table "design_load_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "disposition_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "code", limit: 2, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
  end

  create_table "district_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
  end

  create_table "districts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "district_type_id"
    t.string "name", limit: 64, null: false
    t.string "code", null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
    t.index ["code"], name: "index_districts_on_code"
    t.index ["district_type_id"], name: "index_districts_on_district_type_id"
    t.index ["name"], name: "index_districts_on_name"
  end

  create_table "documents", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "guid", limit: 36
    t.integer "documentable_id", null: false
    t.string "documentable_type", limit: 64, null: false
    t.string "document", limit: 128, null: false
    t.string "description", limit: 254, null: false
    t.string "original_filename", limit: 128, null: false
    t.string "content_type", limit: 128, null: false
    t.integer "file_size", null: false
    t.integer "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["documentable_id", "documentable_type"], name: "documents_idx2"
    t.index ["guid"], name: "index_documents_on_guid"
    t.index ["object_key"], name: "documents_idx1"
  end

  create_table "dual_fuel_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "primary_fuel_type_id"
    t.integer "secondary_fuel_type_id"
    t.boolean "active"
    t.index ["primary_fuel_type_id"], name: "index_dual_fuel_types_on_primary_fuel_type_id"
    t.index ["secondary_fuel_type_id"], name: "index_dual_fuel_types_on_secondary_fuel_type_id"
  end

  create_table "element_classifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.boolean "active"
  end

  create_table "element_definitions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "number"
    t.string "long_name"
    t.string "short_name"
    t.string "description"
    t.bigint "assembly_type_id"
    t.bigint "element_material_id"
    t.bigint "element_classification_id"
    t.string "quantity_unit"
    t.string "quantity_calculation"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_protective", default: false
    t.index ["assembly_type_id"], name: "index_element_definitions_on_assembly_type_id"
    t.index ["element_classification_id"], name: "index_element_definitions_on_element_classification_id"
    t.index ["element_material_id"], name: "index_element_definitions_on_element_material_id"
    t.index ["number"], name: "index_element_definitions_on_number"
  end

  create_table "element_materials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "elements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "guid", limit: 36
    t.bigint "element_definition_id"
    t.bigint "parent_element_id"
    t.bigint "inspection_id"
    t.float "quantity"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["element_definition_id"], name: "index_elements_on_element_definition_id"
    t.index ["guid"], name: "index_elements_on_guid"
    t.index ["inspection_id"], name: "index_elements_on_inspection_id"
    t.index ["object_key"], name: "index_elements_on_object_key"
    t.index ["parent_element_id"], name: "index_elements_on_parent_element_id"
  end

  create_table "feature_safety_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "field_references", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "field_name"
    t.string "name"
    t.string "number"
    t.string "table"
    t.string "abbreviation"
    t.string "short_description"
    t.text "long_description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "tooltip"
  end

  create_table "file_content_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "class_name", limit: 64, null: false
    t.string "builder_name"
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
    t.index ["class_name"], name: "file_content_types_idx2"
    t.index ["name"], name: "file_content_types_idx1"
  end

  create_table "file_status_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
    t.index ["name"], name: "file_status_types_idx1"
  end

  create_table "forms", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.string "roles", limit: 128, null: false
    t.string "controller", limit: 64, null: false
    t.integer "sort_order"
    t.boolean "active", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["object_key"], name: "forms_idx1"
  end

  create_table "foundation_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "frequency_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 32, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
  end

  create_table "fuel_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "code", null: false
    t.string "description", null: false
    t.boolean "active", null: false
  end

  create_table "functional_classes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "highway_components", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "highway_structure_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "active"
    t.string "code"
    t.string "name"
    t.string "description"
    t.string "structure_class"
  end

  create_table "highway_structures", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "highway_structurible_type"
    t.bigint "highway_structurible_id"
    t.string "address1"
    t.string "address2"
    t.string "city"
    t.string "county"
    t.string "state"
    t.string "zip"
    t.bigint "route_signing_prefix_id"
    t.string "route_number"
    t.string "features_intersected"
    t.string "location_description"
    t.decimal "length", precision: 10
    t.date "inspection_date"
    t.boolean "is_temporary"
    t.bigint "structure_status_type_id"
    t.bigint "maintenance_section_id"
    t.float "milepoint"
    t.bigint "region_id"
    t.bigint "maintenance_responsibility_id"
    t.bigint "owner_id"
    t.decimal "approach_roadway_width", precision: 5, scale: 2
    t.text "remarks"
    t.string "structure_key"
    t.string "facility_carried"
    t.bigint "main_span_material_type_id"
    t.bigint "main_span_design_construction_type_id"
    t.string "structure_number"
    t.string "calculated_condition"
    t.integer "lanes_on"
    t.integer "lanes_under"
    t.bigint "highway_structure_type_id"
    t.bigint "historical_significance_type_id"
    t.bigint "inspection_program_id"
    t.index ["highway_structure_type_id"], name: "index_highway_structures_on_highway_structure_type_id"
    t.index ["highway_structurible_type", "highway_structurible_id"], name: "highway_structurible_idx"
    t.index ["historical_significance_type_id"], name: "index_highway_structures_on_historical_significance_type_id"
    t.index ["inspection_program_id"], name: "index_highway_structures_on_inspection_program_id"
    t.index ["main_span_design_construction_type_id"], name: "idx_structures_on_main_span_design_construction_type_id"
    t.index ["main_span_material_type_id"], name: "index_highway_structures_on_main_span_material_type_id"
    t.index ["maintenance_responsibility_id"], name: "index_highway_structures_on_maintenance_responsibility_id"
    t.index ["maintenance_section_id"], name: "index_highway_structures_on_maintenance_section_id"
    t.index ["owner_id"], name: "index_highway_structures_on_owner_id"
    t.index ["region_id"], name: "index_highway_structures_on_region_id"
    t.index ["route_signing_prefix_id"], name: "index_highway_structures_on_route_signing_prefix_id"
    t.index ["structure_number"], name: "index_highway_structures_on_structure_number", unique: true
    t.index ["structure_status_type_id"], name: "index_highway_structures_on_structure_status_type_id"
  end

  create_table "historical_significance_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "image_classifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "category"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "images", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "guid", limit: 36
    t.bigint "base_imagable_id"
    t.string "base_imagable_type"
    t.integer "imagable_id", null: false
    t.string "imagable_type", limit: 64, null: false
    t.string "image", limit: 128, null: false
    t.string "name"
    t.string "description", limit: 254, null: false
    t.boolean "exportable"
    t.string "original_filename", limit: 128, null: false
    t.string "content_type", limit: 128, null: false
    t.integer "file_size", null: false
    t.integer "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float "latitude"
    t.float "longitude"
    t.float "bearing"
    t.bigint "image_classification_id"
    t.string "condition_state"
    t.boolean "is_primary"
    t.string "compass_point"
    t.index ["base_imagable_type", "base_imagable_id"], name: "index_images_on_base_imagable_type_and_base_imagable_id"
    t.index ["guid"], name: "index_images_on_guid"
    t.index ["imagable_id", "imagable_type"], name: "images_idx2"
    t.index ["image_classification_id"], name: "index_images_on_image_classification_id"
    t.index ["object_key"], name: "images_idx1"
  end

  create_table "inspection_programs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inspection_type_settings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.bigint "transam_asset_id"
    t.bigint "inspection_type_id"
    t.integer "frequency_months"
    t.string "description"
    t.boolean "is_required"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inspection_type_id"], name: "index_inspection_type_settings_on_inspection_type_id"
    t.index ["object_key"], name: "index_inspection_type_settings_on_object_key"
    t.index ["transam_asset_id"], name: "index_inspection_type_settings_on_transam_asset_id"
  end

  create_table "inspection_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "can_be_unscheduled"
    t.boolean "can_be_recurring"
    t.boolean "active"
  end

  create_table "inspection_zones", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "active"
  end

  create_table "inspections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "guid", limit: 36
    t.bigint "inspectionible_id"
    t.string "inspectionible_type"
    t.bigint "inspection_type_id"
    t.bigint "inspection_type_setting_id"
    t.string "description"
    t.string "inspection_trip"
    t.string "inspection_fiscal_year"
    t.string "inspection_month"
    t.string "inspection_quarter"
    t.integer "inspection_trip_key"
    t.string "inspection_second_quarter"
    t.integer "inspection_second_trip_key"
    t.bigint "inspection_zone_id"
    t.bigint "transam_asset_id"
    t.bigint "assigned_organization_id"
    t.string "state"
    t.datetime "event_datetime"
    t.date "calculated_inspection_due_date"
    t.integer "temperature"
    t.string "weather"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "qc_inspector_id"
    t.bigint "qa_inspector_id"
    t.datetime "routine_report_submitted_at"
    t.bigint "organization_type_id"
    t.integer "inspection_frequency"
    t.bigint "inspection_team_leader_id"
    t.bigint "inspection_team_member_id"
    t.bigint "inspection_team_member_alt_id"
    t.index ["assigned_organization_id"], name: "index_inspections_on_assigned_organization_id"
    t.index ["guid"], name: "index_inspections_on_guid"
    t.index ["inspection_team_leader_id"], name: "index_inspections_on_inspection_team_leader_id"
    t.index ["inspection_team_member_alt_id"], name: "index_inspections_on_inspection_team_member_alt_id"
    t.index ["inspection_team_member_id"], name: "index_inspections_on_inspection_team_member_id"
    t.index ["inspection_type_id"], name: "index_inspections_on_inspection_type_id"
    t.index ["inspection_type_setting_id"], name: "index_inspections_on_inspection_type_setting_id"
    t.index ["inspection_zone_id"], name: "index_inspections_on_inspection_zone_id"
    t.index ["inspectionible_type", "inspectionible_id"], name: "inspectionible_idx"
    t.index ["object_key"], name: "index_inspections_on_object_key"
    t.index ["organization_type_id"], name: "index_inspections_on_organization_type_id"
    t.index ["qa_inspector_id"], name: "index_inspections_on_qa_inspector_id"
    t.index ["qc_inspector_id"], name: "index_inspections_on_qc_inspector_id"
    t.index ["transam_asset_id"], name: "index_inspections_on_transam_asset_id"
  end

  create_table "inspections_users", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "inspection_id", null: false
    t.bigint "user_id", null: false
    t.index ["inspection_id", "user_id"], name: "index_inspections_users_on_inspection_id_and_user_id"
  end

  create_table "issue_status_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 32, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active"
  end

  create_table "issue_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
  end

  create_table "issues", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "issue_type_id", null: false
    t.integer "web_browser_type_id", null: false
    t.integer "created_by_id", null: false
    t.text "comments", null: false
    t.integer "issue_status_type_id", default: 1
    t.text "resolution_comments"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["issue_type_id"], name: "issues_idx2"
    t.index ["object_key"], name: "issues_idx1"
  end

  create_table "keyword_search_indices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_class", limit: 64, null: false
    t.string "object_key", limit: 12, null: false
    t.integer "organization_id", null: false
    t.string "context", limit: 64, null: false
    t.string "summary", limit: 64, null: false
    t.text "search_text", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["object_class"], name: "keyword_search_indices_idx1"
  end

  create_table "license_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "asset_manager", null: false
    t.boolean "web_services", null: false
    t.boolean "active", null: false
  end

  create_table "load_rating_method_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "location_reference_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "format", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
  end

  create_table "maintenance_sections", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "maintenance_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 32, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
  end

  create_table "manufacturer_models", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.bigint "organization_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_manufacturer_models_on_organization_id"
  end

  create_table "manufacturers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "filter", limit: 32, null: false
    t.string "name", limit: 128, null: false
    t.string "code", limit: 3, null: false
    t.boolean "active", null: false
    t.index ["filter"], name: "manufacturers_idx1"
  end

  create_table "map_overlay_service_types", id: :bigint, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["id"], name: "id", unique: true
  end

  create_table "map_overlay_services", id: :bigint, unsigned: true, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", null: false
    t.integer "organization_id"
    t.integer "created_by_user_id"
    t.integer "map_overlay_service_type_id"
    t.string "name"
    t.string "url"
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["created_by_user_id"], name: "index_map_overlay_services_on_created_by_user_id"
    t.index ["id"], name: "id", unique: true
    t.index ["map_overlay_service_type_id"], name: "index_map_overlay_services_on_map_overlay_service_type_id"
    t.index ["organization_id"], name: "index_map_overlay_services_on_organization_id"
  end

  create_table "mast_arm_frame_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "membrane_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "message_tags", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "message_id"
    t.integer "user_id"
    t.index ["message_id"], name: "message_tags_idx1"
    t.index ["user_id"], name: "message_tags_idx2"
  end

  create_table "message_templates", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "priority_type_id"
    t.string "object_key"
    t.string "name"
    t.string "subject"
    t.text "description"
    t.text "delivery_rules"
    t.text "body"
    t.boolean "active"
    t.boolean "message_enabled"
    t.boolean "email_enabled"
    t.boolean "is_system_template"
    t.boolean "is_implemented"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["priority_type_id"], name: "index_message_templates_on_priority_type_id"
  end

  create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "organization_id", null: false
    t.integer "user_id", null: false
    t.integer "to_user_id"
    t.integer "priority_type_id", null: false
    t.integer "thread_message_id"
    t.string "subject", limit: 64, null: false
    t.text "body"
    t.boolean "active"
    t.datetime "opened_at"
    t.datetime "created_at", null: false
    t.bigint "message_template_id"
    t.string "email_status"
    t.index ["message_template_id"], name: "index_messages_on_message_template_id"
    t.index ["object_key"], name: "messages_idx1"
    t.index ["organization_id"], name: "messages_idx2"
    t.index ["thread_message_id"], name: "messages_idx5"
    t.index ["to_user_id"], name: "messages_idx4"
    t.index ["user_id"], name: "messages_idx3"
  end

  create_table "notice_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.string "display_icon", limit: 64, null: false
    t.string "display_class", limit: 64, null: false
    t.boolean "active"
  end

  create_table "notices", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "subject", limit: 64, null: false
    t.string "summary", limit: 128, null: false
    t.text "details"
    t.integer "notice_type_id"
    t.integer "organization_id"
    t.datetime "display_datetime"
    t.datetime "end_datetime"
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "text", null: false
    t.string "link", null: false
    t.integer "notifiable_id"
    t.string "notifiable_type"
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["notifiable_id", "notifiable_type"], name: "index_notifications_on_notifiable_id_and_notifiable_type"
  end

  create_table "operational_status_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "organization_role_mappings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id", null: false
    t.integer "role_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organization_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "class_name", limit: 64, null: false
    t.string "display_icon_name", limit: 64, null: false
    t.string "map_icon_name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.string "roles"
    t.boolean "active", null: false
    t.index ["class_name"], name: "organization_types_idx1"
  end

  create_table "organizations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_type_id", null: false
    t.integer "customer_id", null: false
    t.bigint "parent_id"
    t.string "external_id", limit: 32
    t.string "name", limit: 128, null: false
    t.string "short_name", limit: 16, null: false
    t.boolean "license_holder", null: false
    t.string "address1", limit: 128, null: false
    t.string "address2", limit: 128
    t.string "county", limit: 64
    t.string "city", limit: 64, null: false
    t.string "state", limit: 2, null: false
    t.string "zip", limit: 10, null: false
    t.string "phone", limit: 12, null: false
    t.string "phone_ext", limit: 6
    t.string "fax", limit: 12
    t.string "url", limit: 128, null: false
    t.boolean "indian_tribe"
    t.string "subrecipient_number", limit: 9
    t.string "ntd_id_number", limit: 4
    t.boolean "active", null: false
    t.decimal "latitude", precision: 11, scale: 6
    t.decimal "longitude", precision: 11, scale: 6
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "country"
    t.string "legal_name"
    t.index ["customer_id"], name: "organizations_idx2"
    t.index ["organization_type_id"], name: "organizations_idx1"
    t.index ["parent_id"], name: "index_organizations_on_parent_id"
    t.index ["short_name"], name: "organizations_idx4"
    t.index ["short_name"], name: "short_name"
  end

  create_table "organizations_saved_queries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "saved_query_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organizations_saved_queries_on_organization_id"
    t.index ["saved_query_id"], name: "index_organizations_saved_queries_on_saved_query_id"
  end

  create_table "organizations_saved_searches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "saved_search_id"
    t.index ["organization_id"], name: "index_organizations_saved_searches_on_organization_id"
    t.index ["saved_search_id"], name: "index_organizations_saved_searches_on_saved_search_id"
  end

  create_table "policies", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "organization_id", null: false
    t.integer "parent_id"
    t.integer "year", null: false
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.integer "service_life_calculation_type_id", null: false
    t.integer "cost_calculation_type_id", null: false
    t.integer "condition_estimation_type_id", null: false
    t.decimal "condition_threshold", precision: 9, scale: 2, null: false
    t.decimal "interest_rate", precision: 9, scale: 2, null: false
    t.boolean "current", null: false
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["object_key"], name: "policies_idx1"
    t.index ["organization_id"], name: "policies_idx2"
  end

  create_table "policy_asset_subtype_rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "policy_id", null: false
    t.integer "asset_subtype_id", null: false
    t.integer "fuel_type_id"
    t.integer "min_service_life_months", null: false
    t.integer "min_service_life_miles"
    t.integer "replacement_cost", null: false
    t.integer "cost_fy_year", null: false
    t.boolean "replace_with_new", null: false
    t.boolean "replace_with_leased", null: false
    t.integer "replace_asset_subtype_id"
    t.integer "replace_fuel_type_id"
    t.integer "lease_length_months"
    t.integer "rehabilitation_service_month"
    t.integer "rehabilitation_labor_cost"
    t.integer "rehabilitation_parts_cost"
    t.integer "extended_service_life_months"
    t.integer "extended_service_life_miles"
    t.integer "min_used_purchase_service_life_months", null: false
    t.string "purchase_replacement_code", limit: 8, null: false
    t.string "lease_replacement_code", limit: 8
    t.string "purchase_expansion_code", limit: 8
    t.string "lease_expansion_code", limit: 8
    t.string "rehabilitation_code", limit: 8, null: false
    t.string "engineering_design_code", limit: 8
    t.string "construction_code", limit: 8
    t.boolean "default_rule"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["asset_subtype_id"], name: "policy_asset_subtype_rules_idx2"
    t.index ["policy_id"], name: "policy_asset_subtype_rules_idx1"
  end

  create_table "policy_asset_type_rules", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "policy_id", null: false
    t.integer "asset_type_id", null: false
    t.integer "service_life_calculation_type_id", null: false
    t.integer "replacement_cost_calculation_type_id", null: false
    t.integer "condition_rollup_calculation_type_id"
    t.decimal "annual_inflation_rate", precision: 9, scale: 2, null: false
    t.integer "pcnt_residual_value", null: false
    t.integer "condition_rollup_weight"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["asset_type_id"], name: "policy_asset_type_rules_idx2"
    t.index ["policy_id"], name: "policy_asset_type_rules_idx1"
  end

  create_table "priority_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "is_default", null: false
    t.boolean "active", null: false
  end

  create_table "processable_uploads", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "class_name", null: false
    t.bigint "file_status_type_id"
    t.bigint "delayed_job_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["delayed_job_id"], name: "index_processable_uploads_on_delayed_job_id"
    t.index ["file_status_type_id"], name: "index_processable_uploads_on_file_status_type_id"
  end

  create_table "query_asset_classes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "table_name"
    t.text "transam_assets_join"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "query_association_classes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "table_name"
    t.string "display_field_name"
    t.string "id_field_name", default: "id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "query_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "query_field_asset_classes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "query_field_id"
    t.bigint "query_asset_class_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["query_asset_class_id"], name: "index_query_field_asset_classes_on_query_asset_class_id"
    t.index ["query_field_id"], name: "index_query_field_asset_classes_on_query_field_id"
  end

  create_table "query_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "label"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "query_category_id"
    t.string "filter_type"
    t.bigint "query_association_class_id"
    t.boolean "hidden"
    t.string "pairs_with"
    t.boolean "auto_show"
    t.string "display_field"
    t.string "column_filter"
    t.string "column_filter_value"
    t.index ["query_association_class_id"], name: "index_query_fields_on_query_association_class_id"
    t.index ["query_category_id"], name: "index_query_fields_on_query_category_id"
  end

  create_table "query_filters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "query_field_id"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "saved_query_id"
    t.string "op"
    t.index ["query_field_id"], name: "index_query_filters_on_query_field_id"
    t.index ["saved_query_id"], name: "index_query_filters_on_saved_query_id"
  end

  create_table "query_params", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.text "query_string"
    t.string "class_name"
    t.boolean "active"
  end

  create_table "reference_feature_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "regions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "replacement_reason_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active"
  end

  create_table "replacement_status_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "active"
  end

  create_table "report_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.string "display_icon_name", limit: 64, null: false
    t.boolean "active", null: false
  end

  create_table "reports", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "report_type_id", null: false
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.string "class_name", null: false
    t.string "view_name", limit: 32, null: false
    t.string "roles", limit: 128
    t.text "custom_sql"
    t.boolean "show_in_nav"
    t.boolean "show_in_dashboard"
    t.string "chart_type", limit: 32
    t.text "chart_options"
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["report_type_id"], name: "reports_idx1"
  end

  create_table "roadbed_lines", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key"
    t.string "guid", limit: 36
    t.bigint "roadbed_id"
    t.bigint "inspection_id"
    t.string "number"
    t.float "entry"
    t.float "exit"
    t.float "minimum_clearance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["inspection_id"], name: "index_roadbed_lines_on_inspection_id"
    t.index ["roadbed_id"], name: "index_roadbed_lines_on_roadbed_id"
  end

  create_table "roadbeds", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key"
    t.string "guid", limit: 36
    t.string "name"
    t.bigint "roadway_id"
    t.string "direction"
    t.integer "number_of_lines"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["roadway_id"], name: "index_roadbeds_on_roadway_id"
  end

  create_table "roadways", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "guid", limit: 36
    t.bigint "transam_asset_id"
    t.string "on_under_indicator"
    t.bigint "route_signing_prefix_id"
    t.bigint "service_level_type_id"
    t.string "route_number"
    t.decimal "min_vertical_clearance", precision: 10
    t.boolean "on_base_network"
    t.string "lrs_route"
    t.string "lrs_subroute"
    t.bigint "functional_class_id"
    t.integer "lanes"
    t.integer "average_daily_traffic"
    t.integer "average_daily_traffic_year"
    t.decimal "total_horizontal_clearance", precision: 10
    t.bigint "strahnet_designation_type_id"
    t.bigint "traffic_direction_type_id"
    t.boolean "on_national_highway_system"
    t.boolean "on_federal_lands_highway"
    t.integer "average_daily_truck_traffic_percent"
    t.boolean "on_truck_network"
    t.integer "future_average_daily_traffic"
    t.integer "future_average_daily_traffic_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "milepoint"
    t.string "facility_carried"
    t.string "features_intersected"
    t.float "lrs_reference_point"
    t.index ["functional_class_id"], name: "index_roadways_on_functional_class_id"
    t.index ["guid"], name: "index_roadways_on_guid"
    t.index ["object_key"], name: "index_roadways_on_object_key"
    t.index ["route_signing_prefix_id"], name: "index_roadways_on_route_signing_prefix_id"
    t.index ["service_level_type_id"], name: "index_roadways_on_service_level_type_id"
    t.index ["strahnet_designation_type_id"], name: "index_roadways_on_strahnet_designation_type_id"
    t.index ["traffic_direction_type_id"], name: "index_roadways_on_traffic_direction_type_id"
    t.index ["transam_asset_id"], name: "index_roadways_on_transam_asset_id"
  end

  create_table "roles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.integer "weight"
    t.integer "resource_id"
    t.string "resource_type"
    t.integer "role_parent_id"
    t.boolean "show_in_user_mgmt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "privilege", default: false, null: false
    t.string "label"
    t.index ["name"], name: "roles_idx1"
    t.index ["resource_id"], name: "roles_idx2"
  end

  create_table "route_signing_prefixes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "rule_sets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key"
    t.string "name"
    t.string "class_name"
    t.boolean "rule_set_aware"
    t.boolean "active"
  end

  create_table "saved_queries", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key"
    t.string "name"
    t.string "description"
    t.integer "created_by_user_id"
    t.integer "updated_by_user_id"
    t.integer "shared_from_org_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "ordered_output_field_ids"
  end

  create_table "saved_query_fields", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "saved_query_id"
    t.bigint "query_field_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["query_field_id"], name: "index_saved_query_fields_on_query_field_id"
    t.index ["saved_query_id"], name: "index_saved_query_fields_on_saved_query_id"
  end

  create_table "saved_searches", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "user_id", null: false
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.integer "search_type_id"
    t.text "json"
    t.text "query_string"
    t.integer "ordinal"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "scour_critical_bridge_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "search_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "class_name"
    t.boolean "active"
  end

  create_table "serial_numbers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "identifiable_type"
    t.bigint "identifiable_id"
    t.string "identification"
    t.index ["identifiable_type", "identifiable_id"], name: "index_serial_numbers_on_identifiable_type_and_identifiable_id"
  end

  create_table "service_level_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "service_life_calculation_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "class_name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
    t.index ["class_name"], name: "service_life_calculation_types_idx1"
  end

  create_table "service_on_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "service_status_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "code", limit: 1, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
  end

  create_table "service_under_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "strahnet_designation_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "streambed_profile_points", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", null: false
    t.string "guid", limit: 36
    t.bigint "streambed_profile_id"
    t.decimal "distance", precision: 10
    t.decimal "value", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["guid"], name: "index_streambed_profile_points_on_guid"
    t.index ["object_key"], name: "index_streambed_profile_points_on_object_key"
    t.index ["streambed_profile_id", "distance"], name: "streambed_profile_id_distance_uniq_idx", unique: true
    t.index ["streambed_profile_id"], name: "index_streambed_profile_points_on_streambed_profile_id"
  end

  create_table "streambed_profiles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", null: false
    t.bigint "transam_asset_id"
    t.string "guid", limit: 36
    t.bigint "inspection_id"
    t.datetime "date"
    t.decimal "water_level", precision: 10
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reference_line"
    t.string "water_level_reference"
    t.index ["guid"], name: "index_streambed_profiles_on_guid"
    t.index ["inspection_id"], name: "index_streambed_profiles_on_inspection_id"
    t.index ["object_key"], name: "index_streambed_profiles_on_object_key"
    t.index ["transam_asset_id"], name: "index_streambed_profiles_on_transam_asset_id"
  end

  create_table "structure_agent_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "structure_material_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "structure_status_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
  end

  create_table "system_config_extensions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "class_name"
    t.string "extension_name"
    t.string "engine_name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "system_configs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "customer_id"
    t.string "start_of_fiscal_year", limit: 5
    t.integer "fy_year"
    t.string "default_fiscal_year_formatter"
    t.string "default_weather_code"
    t.string "map_tile_provider", limit: 64
    t.integer "srid"
    t.float "min_lat"
    t.float "min_lon"
    t.float "max_lat"
    t.float "max_lon"
    t.integer "search_radius"
    t.string "search_units", limit: 8
    t.string "geocoder_components", limit: 128
    t.string "geocoder_region", limit: 64
    t.integer "num_forecasting_years"
    t.integer "num_reporting_years"
    t.integer "max_rows_returned"
    t.string "special_locked_fields"
    t.string "measurement_system"
    t.string "data_file_path", limit: 64
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "tasks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "taskable_id"
    t.string "taskable_type"
    t.integer "user_id", null: false
    t.integer "priority_type_id", null: false
    t.integer "organization_id", null: false
    t.integer "assigned_to_user_id"
    t.string "subject", limit: 64, null: false
    t.text "body", null: false
    t.boolean "send_reminder"
    t.string "state", limit: 32
    t.datetime "complete_by", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assigned_to_user_id"], name: "tasks_idx5"
    t.index ["complete_by"], name: "tasks_idx6"
    t.index ["object_key"], name: "tasks_idx1"
    t.index ["organization_id"], name: "tasks_idx4"
    t.index ["state"], name: "tasks_idx3"
    t.index ["user_id"], name: "tasks_idx2"
  end

  create_table "traffic_direction_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "transam_assets", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "transam_assetible_type"
    t.bigint "transam_assetible_id"
    t.string "object_key", limit: 12, null: false
    t.string "guid", limit: 36
    t.bigint "organization_id", null: false
    t.bigint "asset_subtype_id"
    t.bigint "upload_id"
    t.string "asset_tag", null: false
    t.date "disposition_date"
    t.string "external_id"
    t.text "description"
    t.bigint "manufacturer_id"
    t.string "other_manufacturer"
    t.bigint "manufacturer_model_id"
    t.string "other_manufacturer_model"
    t.integer "manufacture_year"
    t.integer "quantity"
    t.string "quantity_unit"
    t.integer "purchase_cost"
    t.date "purchase_date"
    t.boolean "purchased_new"
    t.date "in_service_date"
    t.bigint "vendor_id"
    t.string "other_vendor"
    t.integer "parent_id"
    t.integer "location_id"
    t.integer "policy_replacement_year"
    t.integer "scheduled_replacement_year"
    t.integer "scheduled_replacement_cost"
    t.text "early_replacement_reason"
    t.boolean "in_backlog"
    t.geometry "geometry"
    t.integer "location_reference_type_id"
    t.string "location_reference"
    t.integer "scheduled_rehabilitation_year"
    t.integer "scheduled_disposition_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["asset_subtype_id"], name: "index_transam_assets_on_asset_subtype_id"
    t.index ["guid"], name: "index_transam_assets_on_guid"
    t.index ["manufacturer_id"], name: "index_transam_assets_on_manufacturer_id"
    t.index ["manufacturer_model_id"], name: "index_transam_assets_on_manufacturer_model_id"
    t.index ["object_key"], name: "index_transam_assets_on_object_key"
    t.index ["organization_id"], name: "index_transam_assets_on_organization_id"
    t.index ["transam_assetible_type", "transam_assetible_id"], name: "transam_assetible_idx"
    t.index ["upload_id"], name: "index_transam_assets_on_upload_id"
    t.index ["vendor_id"], name: "index_transam_assets_on_vendor_id"
  end

  create_table "uploads", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "organization_id"
    t.integer "user_id", null: false
    t.integer "file_content_type_id", null: false
    t.integer "file_status_type_id", null: false
    t.string "file", limit: 128, null: false
    t.string "original_filename", limit: 254, null: false
    t.integer "num_rows_processed"
    t.integer "num_rows_added"
    t.integer "num_rows_replaced"
    t.integer "num_rows_skipped"
    t.integer "num_rows_failed"
    t.text "processing_log", limit: 4294967295
    t.boolean "force_update"
    t.datetime "processing_started_at"
    t.datetime "processing_completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["file_content_type_id"], name: "uploads_idx4"
    t.index ["file_status_type_id"], name: "uploads_idx5"
    t.index ["object_key"], name: "uploads_idx1"
    t.index ["organization_id"], name: "uploads_idx2"
    t.index ["user_id"], name: "uploads_idx3"
  end

  create_table "upper_connection_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_notifications", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "notification_id", null: false
    t.datetime "opened_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["notification_id"], name: "index_user_notifications_on_notification_id"
    t.index ["user_id"], name: "index_user_notifications_on_user_id"
  end

  create_table "user_organization_filters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "sort_order"
    t.integer "created_by_user_id"
    t.text "query_string"
    t.integer "resource_id"
    t.string "resource_type"
    t.index ["created_by_user_id"], name: "index_user_organization_filters_on_created_by_user_id"
    t.index ["object_key"], name: "user_organization_filters_idx1"
  end

  create_table "user_organization_filters_organizations", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_organization_filter_id", null: false
    t.integer "organization_id", null: false
    t.index ["user_organization_filter_id", "organization_id"], name: "user_organization_filters_idx1"
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "organization_id", null: false
    t.string "external_id", limit: 32
    t.string "first_name", limit: 64, null: false
    t.string "last_name", limit: 64, null: false
    t.string "title", limit: 64
    t.string "phone", limit: 12, null: false
    t.string "phone_ext", limit: 6
    t.string "timezone", limit: 32, null: false
    t.string "email", limit: 128, null: false
    t.string "address1", limit: 64
    t.string "address2", limit: 64
    t.string "city", limit: 32
    t.string "state", limit: 2
    t.string "zip", limit: 10
    t.integer "num_table_rows"
    t.integer "user_organization_filter_id"
    t.string "encrypted_password", limit: 64, null: false
    t.string "reset_password_token", limit: 64
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count"
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip", limit: 16
    t.string "last_sign_in_ip", limit: 16
    t.integer "failed_attempts", null: false
    t.string "unlock_token", limit: 128
    t.datetime "locked_at"
    t.datetime "password_changed_at"
    t.boolean "notify_via_email", null: false
    t.integer "weather_code_id"
    t.boolean "active", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "authentication_token", limit: 30
    t.index ["authentication_token"], name: "index_users_on_authentication_token", unique: true
    t.index ["email"], name: "users_idx3"
    t.index ["object_key"], name: "users_idx1"
    t.index ["organization_id"], name: "users_idx2"
  end

  create_table "users_organizations", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "organization_id"
    t.index ["user_id", "organization_id"], name: "users_organizations_idx2"
  end

  create_table "users_roles", id: false, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "role_id", null: false
    t.integer "granted_by_user_id"
    t.date "granted_on_date"
    t.integer "revoked_by_user_id"
    t.date "revoked_on_date"
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["active"], name: "users_roles_idx3"
    t.index ["user_id", "role_id"], name: "users_roles_idx2"
  end

  create_table "users_user_organization_filters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "user_organization_filter_id", null: false
    t.index ["user_id"], name: "users_user_organization_filters_idx1"
    t.index ["user_organization_filter_id"], name: "users_user_organization_filters_idx2"
  end

  create_table "users_viewable_organizations", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "organization_id"
  end

  create_table "vendors", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "organization_id", null: false
    t.string "name", limit: 64, null: false
    t.string "address1", limit: 64
    t.string "address2", limit: 64
    t.string "city", limit: 64
    t.string "state", limit: 2
    t.string "zip", limit: 10
    t.string "phone", limit: 12
    t.string "phone_ext", limit: 6
    t.string "fax", limit: 12
    t.string "url", limit: 128
    t.decimal "latitude", precision: 11, scale: 6
    t.decimal "longitude", precision: 11, scale: 6
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["name"], name: "vendors_idx2"
    t.index ["object_key"], name: "vendors_idx1"
    t.index ["organization_id"], name: "vendors_idx3"
  end

  create_table "versions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "item_type", null: false
    t.integer "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
  end

  create_table "wearing_surface_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "description"
    t.boolean "active"
  end

  create_table "weather_codes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "state", limit: 2
    t.string "code", limit: 8
    t.string "city", limit: 64
    t.boolean "active"
    t.index ["state", "city"], name: "weather_codes_idx"
  end

  create_table "web_browser_types", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 64, null: false
    t.string "description", limit: 254, null: false
    t.boolean "active", null: false
  end

  create_table "workflow_events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "object_key", limit: 12, null: false
    t.integer "accountable_id", null: false
    t.string "accountable_type", limit: 64, null: false
    t.string "event_type", limit: 64, null: false
    t.integer "created_by_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["accountable_id", "accountable_type"], name: "workflow_events_idx2"
    t.index ["object_key"], name: "workflow_events_idx1"
  end

  add_foreign_key "query_field_asset_classes", "query_asset_classes"
  add_foreign_key "query_field_asset_classes", "query_fields"
  add_foreign_key "query_filters", "query_fields"
  add_foreign_key "roadbed_lines", "inspections"
  add_foreign_key "roadbed_lines", "roadbeds"
  add_foreign_key "roadbeds", "roadways"
  add_foreign_key "saved_query_fields", "query_fields"
  add_foreign_key "saved_query_fields", "saved_queries"
  add_foreign_key "streambed_profile_points", "streambed_profiles"
  add_foreign_key "streambed_profiles", "inspections"
end
