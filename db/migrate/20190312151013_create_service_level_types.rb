class CreateServiceLevelTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :service_level_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end
  end
end
