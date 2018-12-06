class CreateBridgeConditionRatingTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :bridge_condition_rating_types do |t|

      t.timestamps
    end
  end
end
