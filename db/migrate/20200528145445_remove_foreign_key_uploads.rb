class RemoveForeignKeyUploads < ActiveRecord::Migration[5.2]
  def change
    remove_foreign_key :inspections, column: :upload_id
    remove_foreign_key :roadways, column: :upload_id
  end
end
