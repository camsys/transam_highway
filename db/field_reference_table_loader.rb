filename = './data/reference_table.csv'

FieldReferenceTable.destroy_all

CSV.foreach(filename, :headers => true) do |row|
  table_name = row[7]
  field_name = row[0]
  label = row[1]

  next if table_name.blank? || field_name.blank? || label.blank?

  number = row[2]
  abbr = row[3]
  short_desc = row[4]
  long_desc = row[5]

  FieldReferenceTable.create(
    name: field_name,
    table: table_name,
    label: label,
    number: number,
    abbr: abbr,
    short_desc: short_desc,
    long_desc: long_desc
    )
end

