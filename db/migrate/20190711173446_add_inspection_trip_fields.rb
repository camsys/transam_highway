class AddInspectionTripFields < ActiveRecord::Migration[5.2]
  def change
    add_column :highway_structures, :inspection_fiscal_year, :string
    add_column :highway_structures, :inspection_month, :string
    add_column :highway_structures, :inspection_quarter, :string
    add_column :highway_structures, :inspection_trip_key, :integer
    add_column :highway_structures, :inspection_second_quarter, :string
    add_column :highway_structures, :inspection_second_trip_key, :integer
  end
end
