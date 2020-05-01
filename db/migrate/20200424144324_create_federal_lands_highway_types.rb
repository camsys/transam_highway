class CreateFederalLandsHighwayTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :federal_lands_highway_types do |t|
      t.string :code
      t.string :name
      t.string :description
      t.boolean :active

      t.timestamps
    end
  end
end
