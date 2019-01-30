class CreateElementInspectionTables < ActiveRecord::Migration[5.2]
  def change
    create_table :element_definitions do |t|
      t.integer :number
      t.string :long_name
      t.string :short_name
      t.references :element_material
      t.text :notes
      t.string :quantity_unit

      t.timestamps
    end

    create_table :element_materials do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end

    create_table :defect_definitions do |t|
      t.integer :number
      t.string :short_name
      t.string :long_name
      t.text :notes
      t.string :condition_state_1_def
      t.string :condition_state_2_def
      t.string :condition_state_3_def
      t.string :condition_state_4_def


      t.timestamps
    end

    create_table :elements do |t|
      t.string :object_key
      t.references :element_definition
      t.references :parent
      t.references :inspection
      t.integer :quantity
      t.text :notes

      t.timestamps
    end

    create_table :defects do |t|
      t.string :object_key
      t.references :element
      t.references :defect_definition
      t.references :inspection
      t.integer :condition_state_1_quantity
      t.integer :condition_state_2_quantity
      t.integer :condition_state_3_quantity
      t.integer :condition_state_4_quantity
      t.integer :total_quantity
      t.text :notes

      t.timestamps
    end

    create_table :inspections do |t|
      t.string :object_key
      t.references :transam_asset
      t.string :name
      t.datetime :event_datetime
      t.integer :temperature
      t.string :weather
      t.text :notes

      t.timestamps
    end

    create_join_table :inspections, :users do |t|
      t.index [:inspection_id, :user_id]
    end




  end
end
