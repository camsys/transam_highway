class CreateDefectLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :defect_locations do |t|
      t.string :object_key
      if ActiveRecord::Base.configurations[Rails.env]['adapter'].include?('mysql2')
        t.string :guid, limit: 36
      else
        t.uuid :guid
      end
      t.references :defect, foreign_key: true
      t.float :quantity
      t.string :location_description
      t.integer :location_distance
      t.string :condition_state
      t.string :note

      t.timestamps
    end
  end
end
