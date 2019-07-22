class AddFieldsToRoadway < ActiveRecord::Migration[5.2]
  def change
    add_column :roadways, :milepoint, :float
    add_column :roadways, :facility_carried, :string
    add_column :roadways, :features_intersected, :string
  end
end
