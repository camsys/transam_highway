class CreateHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    create_table :highway_structures do |t|
      t.references :highway_structurible, polymorphic: true, index: {name: :highway_structurible_idx}
      t.string :address1
      t.string :address2
      t.string :city
      t.string :county
      t.string :state
      t.string :zip
      t.references :route_signing_prefix
      t.string :route_number
      t.string :features_intersected
      t.string :structure_number
      t.string :location_description #an NBI descriptive text to specify where structure is located, outside of full address
      t.decimal :length

      t.date :inspection_date
      t.integer :inspection_frequency
      t.boolean :fracture_critical_inspection_required
      t.integer :fracture_critical_inspection_frequency
      t.boolean :underwater_inspection_required
      t.integer :underwater_inspection_frequency
      t.boolean :other_special_inspection_required
      t.integer :other_special_inspection_frequency
      t.date :fracture_critical_inspection_date
      t.date :underwater_inspection_date
      t.date :other_special_inspection_date
      t.boolean :is_temporary

    end
  end
end
