class CreateProcessableUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :processable_uploads do |t|
      t.string :class_name, null: false
      t.references :file_status_type
      t.references :delayed_job

      t.timestamps
    end
  end
end
