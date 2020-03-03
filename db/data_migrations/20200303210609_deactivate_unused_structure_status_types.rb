class DeactivateUnusedStructureStatusTypes < ActiveRecord::DataMigration
  def up
    StructureStatusType.where.not(name: ['Active', 'Inactive', 'Proposed']).update_all(active: false)
  end
end