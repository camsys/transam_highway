class AddCalculatedConditionToHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    add_column :highway_structures, :calculated_condition, :string
  end
end
