class AddIndexToElementDefinition < ActiveRecord::Migration[5.2]
  def change
    add_index :element_definitions, :number
  end
end
