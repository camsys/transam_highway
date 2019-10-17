class FixSshmlTypes < ActiveRecord::Migration[5.2]
  def change
    remove_reference :bridge_likes, :mast_arm_frame_type
    remove_reference :bridge_likes, :column_type
    remove_reference :bridge_likes, :foundation_type
    add_reference :bridge_likes, :mast_arm_frame_type
    add_reference :bridge_likes, :column_type
    add_reference :bridge_likes, :foundation_type
  end
end
