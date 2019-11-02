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

    remove_column :highway_structures, :inspection_frequency
    remove_column :highway_structures, :fracture_critical_inspection_required
    remove_column :highway_structures, :fracture_critical_inspection_frequency
    remove_column :highway_structures, :fracture_critical_inspection_date
    remove_column :highway_structures, :underwater_inspection_required
    remove_column :highway_structures, :underwater_inspection_frequency
    remove_column :highway_structures, :underwater_inspection_date
    remove_column :highway_structures, :other_special_inspection_required
    remove_column :highway_structures, :other_special_inspection_frequency
    remove_column :highway_structures, :other_special_inspection_date
  end
end
