class CreateBridges < ActiveRecord::Migration[5.2]
  def change
    create_table :bridges do |t|
      t.string :facility_carried
      t.references :operational_status_type
      t.references :main_span_material_type
      t.references :main_span_design_construction_type
      t.references :approach_spans_material_type
      t.references :approach_spans_design_construction_type
      t.integer :num_spans_main
      t.integer :num_spans_approach
      t.references :deck_condition_rating_type
      t.references :superstructure_condition_rating_type
      t.references :substructure_condition_rating_type
      t.references :channel_condition_type

      t.references :structural_appraisal_rating_type
      t.references :deck_geometry_appraisal_rating_type
      t.references :underclearance_appraisal_rating_type
      t.references :waterway_appraisal_rating_type
      t.references :approach_alignment_appraisal_rating_type
      t.string :border_bridge_state
      t.integer :border_bridge_pcnt_responsibility
      t.string :border_bridge_structure_number
      t.references :strahnet_designation_type
      t.references :deck_structure_type
      t.references :wearing_surface_type
      t.references :membrane_type
      t.references :deck_protection_type
      t.references :scour_critical_bridge_type
    end
  end
end