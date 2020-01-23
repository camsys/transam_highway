class CleanupImageClassificationsBridgeInsp < ActiveRecord::DataMigration
  def up
    [{active: true, name: 'Elevation From Upstream (Looking X)',category: 'Inspection-Bridge'},
     {active: true, name: 'Underbridge/Superstructure',category: 'Inspection-Bridge'}].each do |img_classification|
      classifications = ImageClassification.where(name: img_classification[:name])
      if classifications.count > 1
        Image.where(image_classification: classifications).update_all(image_classification_id: classifications.first.id)
        ImageClassification.where(name: img_classification[:name]).where.not(id: classifications.first.id).destroy_all
      end
      classifications.first.update!(category: img_classification[:category])
    end
  end
end