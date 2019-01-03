class RemoveTimestampsFromWearingSurfaceTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :wearing_surface_types, :created_at, :string
    remove_column :wearing_surface_types, :updated_at, :string
  end
end
