class AddSshmlDefectElementMapping < ActiveRecord::DataMigration
  def up
    {
      1000 => [610, 611, 612, 620, 630, 631, 640, 650, 651, 661, 662, 663],
      1010 => [610, 611, 612, 620, 630, 631, 640, 661, 662, 663],
      1020 => [610, 630, 640, 661, 662, 663],
      1080 => [601, 621, 660],
      1090 => [601, 660],
      1110 => [601, 621],
      1120 => [601, 621, 660],
      1130 => [601, 621, 660],
      1190 => [601, 621, 660],
      1900 => [610, 611, 620, 630, 640, 661],
      7000 => [610, 611, 612, 620, 630, 631, 640, 661, 662, 663]
    }.each do |defect, elements|
      elt_defs = DefectDefinition.find_by(number: defect).element_definitions
      new_elts = elements - elt_defs.pluck(:number)
      elt_defs << ElementDefinition.where(number: new_elts)
    end
  end
end
