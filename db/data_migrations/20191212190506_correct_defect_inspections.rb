class CorrectDefectInspections < ActiveRecord::DataMigration
  def up
    Defect.all.each do |defect|
      defect.update(inspection: defect.element.inspection)
    end
  end
end