class AddAdditionalNbiFieldsBrdgLikesHwyStructsRdwys < ActiveRecord::Migration[5.2]
  def change
    add_reference :bridge_likes, :median_type, foreign_key: true
    add_column :highway_structures, :is_flared, :boolean
    add_column :highway_structures, :skew, :integer
    add_column :roadways, :detour_length, :float
  end
end
