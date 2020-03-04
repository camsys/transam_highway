class DropHighwayTeams < ActiveRecord::Migration[5.2]
  def change
    if column_exists? :organizations, :parent_id
      remove_reference :organizations, :parent
    end
  end
end
