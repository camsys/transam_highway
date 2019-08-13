class AddLrsReferencePointToRoadway < ActiveRecord::Migration[5.2]
  def change
    add_column :roadways, :lrs_reference_point, :float
  end
end
