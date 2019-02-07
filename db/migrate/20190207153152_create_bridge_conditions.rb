class CreateBridgeConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :bridge_conditions do |t|

      t.references :deck_condition_rating_type
      t.references :superstructure_condition_rating_type
      t.references :substructure_condition_rating_type

      t.references :structural_appraisal_rating_type
      t.references :deck_geometry_appraisal_rating_type
      t.references :underclearance_appraisal_rating_type
      t.references :waterway_appraisal_rating_type
      t.references :approach_alignment_appraisal_rating_type

      t.references :operational_status_type
      t.references :channel_condition_type
      t.references :scour_critical_bridge_type

      t.references :railings_safety_type
      t.references :transitions_safety_type
      t.references :approach_rail_safety_type
      t.references :approach_rail_end_safety_type
    end

    remove_column :bridges, :deck_condition_rating_type_id
    remove_column :bridges, :superstructure_condition_rating_type_id
    remove_column :bridges, :substructure_condition_rating_type_id

    remove_column :bridges, :structural_appraisal_rating_type_id
    remove_column :bridges, :deck_geometry_appraisal_rating_type_id
    remove_column :bridges, :underclearance_appraisal_rating_type_id
    remove_column :bridges, :waterway_appraisal_rating_type_id
    remove_column :bridges, :approach_alignment_appraisal_rating_type_id

    remove_column :bridges, :operational_status_type_id
    remove_column :bridges, :channel_condition_type_id
    remove_column :bridges, :scour_critical_bridge_type_id

    add_column :inspections, :inspectionible, polymorphic: true, index: {name: :inspectionible_idx}, after: :object_key


    create_table :feature_safety_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end

  end
end
