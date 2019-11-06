class CreateInspectionTypeSettings < ActiveRecord::Migration[5.2]
  def change
    create_table :inspection_type_settings do |t|
      t.string :object_key, index: true, limit: 12, null: false
      t.references :transam_asset, index: true
      t.references :inspection_type
      t.integer :frequency_months
      t.string :description
      t.boolean :is_required
      t.timestamps
    end

    add_column :inspection_types, :can_be_recurring, :boolean, after: :description
    add_column :inspection_types, :can_be_unscheduled, :boolean, after: :description
    add_column :inspections, :description, :string, after: :inspection_type_id

    add_reference :inspections, :inspection_program, after: :description
    add_column :inspections, :inspection_trip, :string, after: :inspection_program_id
    add_column :inspections, :inspection_fiscal_year, :string, after: :inspection_trip
    add_column :inspections, :inspection_month, :string, after: :inspection_fiscal_year
    add_column :inspections, :inspection_quarter, :string, after: :inspection_month
    add_column :inspections, :inspection_trip_key, :integer, after: :inspection_quarter
    add_column :inspections, :inspection_second_quarter, :string, after: :inspection_trip_key
    add_column :inspections, :inspection_second_trip_key, :integer, after: :inspection_second_quarter
    add_reference :inspections, :inspection_zone, after: :inspection_second_trip_key

    remove_column :highway_structures, :fracture_critical_inspection_required
    remove_column :highway_structures, :fracture_critical_inspection_frequency
    remove_column :highway_structures, :fracture_critical_inspection_date
    remove_column :highway_structures, :underwater_inspection_required
    remove_column :highway_structures, :underwater_inspection_frequency
    remove_column :highway_structures, :underwater_inspection_date
    remove_column :highway_structures, :other_special_inspection_required
    remove_column :highway_structures, :other_special_inspection_frequency
    remove_column :highway_structures, :other_special_inspection_date

    remove_column :highway_structures, :inspection_program_id
    remove_column :highway_structures, :inspection_trip
    remove_column :highway_structures, :inspection_fiscal_year
    remove_column :highway_structures, :inspection_month
    remove_column :highway_structures, :inspection_quarter
    remove_column :highway_structures, :inspection_trip_key
    remove_column :highway_structures, :inspection_second_quarter
    remove_column :highway_structures, :inspection_second_trip_key
    remove_column :highway_structures, :inspection_zone_id
  end
end
