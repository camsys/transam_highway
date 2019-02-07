class CreateBridgeConditions < ActiveRecord::Migration[5.2]
  def change
    create_table :bridge_conditions do |t|

      t.references :deck_condition_rating_type, index: false
      t.references :superstructure_condition_rating_type, index: false
      t.references :substructure_condition_rating_type, index: false

      t.references :structural_appraisal_rating_type, index: false
      t.references :deck_geometry_appraisal_rating_type, index: false
      t.references :underclearance_appraisal_rating_type, index: false
      t.references :waterway_appraisal_rating_type, index: false
      t.references :approach_alignment_appraisal_rating_type, index: false

      t.references :operational_status_type, index: false
      t.references :channel_condition_type, index: false
      t.references :scour_critical_bridge_type, index: false

      t.references :railings_safety_type, index: false
      t.references :transitions_safety_type, index: false
      t.references :approach_rail_safety_type, index: false
      t.references :approach_rail_end_safety_type, index: false
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

    add_reference :inspections, :inspectionible, polymorphic: true, index: {name: :inspectionible_idx}, after: :object_key


    create_table :feature_safety_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end

  end
end
