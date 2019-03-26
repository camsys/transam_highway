class RenameBridgeToBridgeLike < ActiveRecord::Migration[5.2]
  def change
    rename_index :bridges, :index_bridges_on_approach_spans_design_construction_type_id, :idx_bridge_likes_on_approach_spans_design_construction_type_id
    rename_table :bridges, :bridge_likes
    rename_table :bridge_conditions, :bridge_like_conditions
  end
end
