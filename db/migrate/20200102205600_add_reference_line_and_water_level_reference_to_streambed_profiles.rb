class AddReferenceLineAndWaterLevelReferenceToStreambedProfiles < ActiveRecord::Migration[5.2]
  def change
    add_column :streambed_profiles, :reference_line, :string
    add_column :streambed_profiles, :water_level_reference, :string
  end
end
