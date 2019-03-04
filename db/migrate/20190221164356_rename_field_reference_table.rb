class RenameFieldReferenceTable < ActiveRecord::Migration[5.2]
  def self.up
    rename_table :field_reference_tables, :field_references
  end

  def self.down
    rename_table :field_references, :field_reference_tables
  end
end
