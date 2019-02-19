class FieldReferenceTable < ApplicationRecord
  def self.get_label(table_name, field_name)
    f = FieldReferenceTable.find_by(table: table_name, name: field_name)
    f && (f.number ? "#{f.label} (#{f.number})" : f.label)
  end
end
