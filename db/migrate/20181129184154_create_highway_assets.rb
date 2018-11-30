class CreateHighwayAssets < ActiveRecord::Migration[5.2]
  def change
    create_table :highway_assets do |t|
      t.text :test_notes
      t.references :highway_assetible, polymorphic: true, index: {name: :highway_assetible_idx}

      t.timestamps
    end

  end
end
