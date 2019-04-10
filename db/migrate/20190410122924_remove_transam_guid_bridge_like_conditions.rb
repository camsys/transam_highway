class RemoveTransamGuidBridgeLikeConditions < ActiveRecord::Migration[5.2]
  def change
    if column_exists? :bridge_like_conditions, :guid
      remove_column :bridge_like_conditions, :guid
    end
  end
end
