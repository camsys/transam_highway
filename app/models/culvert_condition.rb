class CulvertCondition < BridgeLikeCondition

  belongs_to :culvert_condition_type

  validates :culvert_condition_type, presence: true

  after_save :update_calculated_condition

  FORM_PARAMS = [
      :culvert_condition_type_id
  ]

  def calculated_condition
    case culvert_condition_type&.value
      when 0..4
        'poor'
      when 5..6
        'fair'
      when 7..9
        'good'
      else
        'unknown'
    end
  end

  def update_calculated_condition
    if self.saved_change_to_attribute?(:culvert_condition_type_id)
      ta = TransamAsset.get_typed_asset(self.highway_structure)
      ta.try(:set_calculated_condition!) if ta
    end
  end

  def has_required_photos?
    (ImageClassification.where(id: images.select(:image_classification_id)).distinct.pluck(:name) & ["Roadway Looking Ahead on Inventory", "Culvert Inlet", "Culvert Outlet"]).count == 3
  end

end
