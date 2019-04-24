class SeedProtectiveSystemElementDefinitions < ActiveRecord::DataMigration
  def up
    ElementDefinition.where(number: [510, 515, 520, 521]).update_all(is_protective: true)
  end
end