class CreateBridgeConditionRatingTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :bridge_condition_rating_types do |t|
      t.string :name
      t.string :code
      t.string :description
      t.boolean :active
    end
  end
end
