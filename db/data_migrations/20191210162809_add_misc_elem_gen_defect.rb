class AddMiscElemGenDefect < ActiveRecord::DataMigration
  def up
    elem = ElementDefinition.create!(number: 700, short_name: 'Miscellaneous',
                                     long_name: 'Miscellaneous Element', quantity_unit: 'each',
                                     description: 'This element is used when no other defined element applies.',
                                     element_material: ElementMaterial.find_by(code: '0'),
                                     element_classification: ElementClassification.find_by(name: 'NBE'),
                                     assembly_type: AssemblyType.find_by(name: 'Other'))
    defect = DefectDefinition.create!(number: 8000, short_name: 'General', long_name: 'General Defect',
                                      description: 'This defect is used to report conditions not captured by any other defect.')
    defect.element_definitions << elem
  end
end
