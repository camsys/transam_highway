class CreateHighwayComponents < ActiveRecord::Migration[5.2]
  def change
    create_table :highway_components do |t|

      t.timestamps
    end
  end
end
