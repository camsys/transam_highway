class CreateInspectionZones < ActiveRecord::Migration[5.2]
  def change
    create_table :inspection_zones do |t|
      t.string :name
      t.string :description
      t.boolean :active
    end

    add_reference :highway_structures, :inspection_zone, after: :inspection_trip
  end
end
