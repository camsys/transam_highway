class AddIndexToDefectDefinition < ActiveRecord::Migration[5.2]
  def change
    add_index :defect_definitions, :number
  end
end
