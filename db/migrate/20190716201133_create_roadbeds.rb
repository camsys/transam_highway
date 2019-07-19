class CreateRoadbeds < ActiveRecord::Migration[5.2]
  def change
    create_table :roadbeds do |t|
      t.string :object_key

      if ActiveRecord::Base.configurations[Rails.env]['adapter'].include?('mysql2')
        t.string :guid, limit: 36
      else
        t.uuid :guid
      end
      
      t.string :name
      t.references :roadway, foreign_key: true
      t.string :direction
      t.integer :number_of_lines

      t.timestamps
    end
  end
end
