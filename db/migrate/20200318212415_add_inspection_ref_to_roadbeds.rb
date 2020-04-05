class AddInspectionRefToRoadbeds < ActiveRecord::Migration[5.2]
  def change
    add_reference :roadbeds, :inspection, foreign_key: true
  end
end
