class AddSshmlTypesToBridgeLike < ActiveRecord::Migration[5.2]
  def change
    add_reference :bridge_likes, :mast_arm_frame_type, foreign_key: true
    add_reference :bridge_likes, :column_type, foreign_key: true
    add_reference :bridge_likes, :foundation_type, foreign_key: true
  end
end
