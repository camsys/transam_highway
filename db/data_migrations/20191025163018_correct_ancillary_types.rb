class CorrectAncillaryTypes < ActiveRecord::DataMigration
  def up
    ColumnType.find_or_create_by!(name: 'Unknown', code: 'U', active: true)
    ColumnType.find_or_create_by!(name: 'Non-Standard', code: 'NS', active: true)

    MastArmFrameType.find_by(code: 'OTHER')&.update_attributes(name: 'Non-Standard', code: 'NS')

    [
      ["SNGL ARM", "DBL ARM", "DBL ARM TRUSS", "BOX BEAM TRUSS", "TRI ARM", "MONOTUBE", "SPAN WIRE"],
      ['SA', 'DA', 'DAT', 'BBT', 'TA', 'M', 'SW']
    ].transpose.each{|old, new| MastArmFrameType.find_by(code: old)&.update_attributes(code: new)}
  end
end
