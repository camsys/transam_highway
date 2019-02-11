class FixElementClassification < ActiveRecord::DataMigration
  def up
    bme = ElementClassification.find_by(name: 'MBE')
    bme.update_columns(name: 'BME') if bme
  end
end