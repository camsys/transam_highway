class SetForceUpdateOnExistingUploadsToTrue < ActiveRecord::DataMigration
  def up
    Upload.update_all(force_update: true)
  end
end