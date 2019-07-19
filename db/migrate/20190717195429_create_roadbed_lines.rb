class CreateRoadbedLines < ActiveRecord::Migration[5.2]
  def change
    create_table :roadbed_lines do |t|
      t.string :object_key
      
      if ActiveRecord::Base.configurations[Rails.env]['adapter'].include?('mysql2')
        t.string :guid, limit: 36
      else
        t.uuid :guid
      end

      t.references :roadbed, foreign_key: true
      t.references :inspection, foreign_key: true
      t.integer :number
      t.float :entry
      t.float :exit

      t.timestamps
    end
  end
end
