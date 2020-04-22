class AddUploadRefToInspectionsAndRoadways < ActiveRecord::Migration[5.2]
  def change
    add_reference :inspections, :upload, foreign_key: true
    add_reference :roadways, :upload, foreign_key: true
  end
end
