class CreateAncillaryConditionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :ancillary_condition_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end

    add_reference :bridge_like_conditions, :ancillary_condition_type
  end
end
