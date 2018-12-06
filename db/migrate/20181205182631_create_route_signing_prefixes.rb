class CreateRouteSigningPrefixes < ActiveRecord::Migration[5.2]
  def change
    create_table :route_signing_prefixes do |t|
      t.string :name
      t.string :code
      t.boolean :active
    end
  end
end
