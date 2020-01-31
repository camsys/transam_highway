class SaveVersionFinalInspections < ActiveRecord::DataMigration
  def up
    Inspection.where(state: 'final').each{|insp| insp.paper_trail.save_with_version}

    #force a version for a state change so has assigned version
    Inspection.where.not(state: ['open', 'ready', 'final']).each do |insp|
      insp.paper_trail.save_with_version
      insp.versions.last.update_columns(object_changes: "---\nstate:\n- #{insp.state}\n- #{insp.state}\n")
    end
  end
end