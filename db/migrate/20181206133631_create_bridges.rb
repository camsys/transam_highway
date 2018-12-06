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
    end
  end
end
