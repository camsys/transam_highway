class MakeElementQuantityFieldsFloat < ActiveRecord::Migration[5.2]
  def change
    change_column :elements, :quantity, :float

    change_column :defects, :condition_state_1_quantity, :float
    change_column :defects, :condition_state_2_quantity, :float
    change_column :defects, :condition_state_3_quantity, :float
    change_column :defects, :condition_state_4_quantity, :float
    change_column :defects, :total_quantity, :float
  end
end
