class AddUpperConnectionTypeToBridgeLike < ActiveRecord::Migration[5.2]
  def change
    add_reference :bridge_likes, :upper_connection_type
  end
end
