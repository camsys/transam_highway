class FieldReference < ApplicationRecord
  validates :table, presence: true
  validates :field_name, presence: true

  def self.get_label(table_name, field_name)
    f = FieldReference.find_by(table: table_name, field_name: field_name)
    if f
      lable_txt = f.short_description.blank? ? f.name : f.short_description

      f.number ? "#{lable_txt} (#{f.number})" : lable_txt
    end
  end
end
