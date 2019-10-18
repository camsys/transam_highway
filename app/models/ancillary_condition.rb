class AncillaryCondition < BridgeLikeCondition

  belongs_to :ancillary_condition_type

  # validates :ancillary_condition_type, presence: true

  after_save :update_calculated_condition

  FORM_PARAMS = [
      :ancillary_condition_type_id
  ]

  def calculated_condition
    case ancillary_condition_type&.value
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
    if self.saved_change_to_attribute?(:ancillary_condition_type_id)
      ta = TransamAsset.get_typed_asset(self.highway_structure)
      ta.try(:set_calculated_condition!) if ta
    end
  end
end
