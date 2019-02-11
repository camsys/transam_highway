class CreateInspectionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :inspection_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end

    add_reference :inspections, :inspection_type, after: :object_key
  end
end
