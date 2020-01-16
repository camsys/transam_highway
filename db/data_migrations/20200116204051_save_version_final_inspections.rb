class SaveVersionFinalInspections < ActiveRecord::DataMigration
  def up
    Inspection.where(state: 'final').each{|insp| insp.paper_trail.save_with_version}
  end
end