class CreateMastArmFrameTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :mast_arm_frame_types do |t|
      t.string :name
      t.string :code
      t.boolean :active

      t.timestamps
    end
  end
end
