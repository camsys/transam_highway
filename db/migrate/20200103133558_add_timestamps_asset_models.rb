class AddTimestampsAssetModels < ActiveRecord::Migration[5.2]
  def change
    add_timestamps(:highway_structures, null: true)
    add_timestamps(:bridge_likes, null: true)

    unless Rails.env.test?
      BridgeLike.all.each do |a|
        a.update_columns(created_at: a.transam_asset.created_at, updated_at: a.transam_asset.updated_at)
        a.highway_structure.update_columns(created_at: a.transam_asset.created_at, updated_at: a.transam_asset.updated_at)
      end
    end

    change_column_null(:highway_structures, :created_at, false)
    change_column_null(:highway_structures, :updated_at, false)
    change_column_null(:bridge_likes, :created_at, false)
    change_column_null(:bridge_likes, :updated_at, false)
  end
end
