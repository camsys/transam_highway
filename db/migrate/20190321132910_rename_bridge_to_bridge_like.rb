class RenameBridgeConditionToBridgeLikeCondition < ActiveRecord::Migration[5.2]
  def change
    rename_table :bridges, :bridge_likes
    rename_table :bridge_conditions, :bridge_like_conditions
  end
end
