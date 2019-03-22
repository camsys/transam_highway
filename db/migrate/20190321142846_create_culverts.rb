class CreateCulverts < ActiveRecord::Migration[5.2]
  def change
    create_table :culvert_condition_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end

    add_reference :bridge_like_conditions, :culvert_condition_type
  end
end
