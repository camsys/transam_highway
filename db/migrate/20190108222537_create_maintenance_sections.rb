class CreateMaintenanceSections < ActiveRecord::Migration[5.2]
  def change
    create_table :maintenance_sections do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end
  end
end
