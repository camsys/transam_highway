class CreateJoinTableAssemblyTypesAssetTypes < ActiveRecord::Migration[5.2]
  def change
    create_join_table :assembly_types, :asset_types do |t|
    end
  end
end
