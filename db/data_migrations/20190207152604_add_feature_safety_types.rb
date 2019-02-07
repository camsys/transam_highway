class AddFeatureSafetyTypes < ActiveRecord::DataMigration
  def up
    [
        {code: '0', name:	'Not acceptable', description:	'Inspected feature does not meet currently acceptable stds. or a safety feature is required and none is provided.', active: true},
        {code: '1', name:	'Acceptable',	description: 'Inpected feature meets currently acceptable standards.'},
        {code: 'N', name:'Not applicable', description:	'Not applicable or a safety feature is not required.'}
    ].each do |type|
      FeatureSafetyType.create!(type)
    end
  end
end