class RemoveDefectLocationsForeignKey < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :defect_locations, :defects
  end
end
