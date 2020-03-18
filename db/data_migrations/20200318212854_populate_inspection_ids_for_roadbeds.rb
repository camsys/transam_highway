class PopulateInspectionIdsForRoadbeds < ActiveRecord::DataMigration
  def up
    Roadbed.joins(:roadbed_lines).uniq.each do |r|
      r.update(inspection: r.roadbed_lines.first.inspection)
    end
  end
end