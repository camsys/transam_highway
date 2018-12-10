class CreateScourCriticalBridgeTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :scour_critical_bridge_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end
