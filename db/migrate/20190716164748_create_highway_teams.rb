class CreateHighwayTeams < ActiveRecord::Migration[5.2]
  def change
    add_reference :organizations, :parent, after: :customer_id
  end
end
