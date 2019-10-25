class CombineEntryExitVerticalClearance < ActiveRecord::Migration[5.2]
  def change
    add_column :roadbed_lines, :minimum_clearance, :float, after: :exit
  end
end
