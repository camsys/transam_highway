class AddRemarksToHighwayStructure < ActiveRecord::Migration[5.2]
  def change
    add_column :highway_structures, :remarks, :text
  end
end
