class AddFeatureSafetyTypes < ActiveRecord::DataMigration
  def up
    [
        {code: '0', name:	'Not acceptable', description:	'Inspected feature does not meet currently acceptable stds. or a safety feature is required and none is provided.', active: true},
        {code: '1', name:	'Acceptable',	description: 'Inpected feature meets currently acceptable standards.', active: true},
        {code: 'N', name:'Not applicable', description:	'Not applicable or a safety feature is not required.', active: true}
    ].each do |type|

      seed = FeatureSafetyType.find_by(name: type[:name])
      if seed
        seed.update!(type)
      else
        FeatureSafetyType.create!(type)
      end
    end
  end
end