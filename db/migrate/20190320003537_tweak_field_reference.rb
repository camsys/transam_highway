class TweakFieldReference < ActiveRecord::Migration[5.2]
  def change
    rename_column :field_references, :name, :field_name
    rename_column :field_references, :label, :name
    rename_column :field_references, :abbr, :abbreviation
    rename_column :field_references, :short_desc, :short_description
    rename_column :field_references, :long_desc, :long_description
    add_column :field_references, :tooltip, :text
  end
end
