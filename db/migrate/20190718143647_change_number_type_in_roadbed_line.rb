class ChangeNumberTypeInRoadbedLine < ActiveRecord::Migration[5.2]
  def change
    change_column :roadbed_lines, :number, :string
  end
end
