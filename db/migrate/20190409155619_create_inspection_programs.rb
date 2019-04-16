class CreateInspectionPrograms < ActiveRecord::Migration[5.2]
  def change
    create_table :inspection_programs do |t|
      t.string :name
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end
