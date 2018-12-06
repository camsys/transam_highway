class CreateChannelConditionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :channel_condition_types do |t|

      t.timestamps
    end
  end
end
