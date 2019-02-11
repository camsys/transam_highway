class AddFieldsHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    create_table :structure_agent_types do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end

    add_reference :highway_structures, :maintenance_responsibility
    add_reference :highway_structures, :owner
    add_column :highway_structures, :approach_roadway_width, :decimal, precision: 5, scale: 2

  end
end
