class PopulateInspectionIdsForRoadbeds < ActiveRecord::DataMigration
  def up
    Roadbed.all.each do |r|
      r.update(inspection: r.roadbed_lines.first&.inspection)
    end
  end
end