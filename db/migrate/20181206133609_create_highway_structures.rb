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

    end
  end
end
