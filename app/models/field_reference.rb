class FieldReference < ApplicationRecord
  validates :table, presence: true
  validates :name, presence: true

  def self.get_label(table_name, field_name)
    f = FieldReference.find_by(table: table_name, name: field_name)
    if f
      lable_txt = f.short_desc.blank? ? f.label : f.short_desc

      f.number ? "#{lable_txt} (#{f.number})" : lable_txt
    end
  end
end
