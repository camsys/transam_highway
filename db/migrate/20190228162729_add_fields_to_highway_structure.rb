class AddFieldsToHighwayStructure < ActiveRecord::Migration[5.2]
  def change
    add_column :highway_structures, :facility_carried, :string
    add_reference :highway_structures, :main_span_material_type
    add_reference :highway_structures, :main_span_design_construction_type,
                  index: {name: 'idx_structures_on_main_span_design_construction_type_id' }
  end
end
