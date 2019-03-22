class Bridge < BridgeLike

  belongs_to :deck_structure_type
  belongs_to :wearing_surface_type
  belongs_to :membrane_type
  belongs_to :deck_protection_type

  has_many :bridge_conditions, through: :inspections, source: :inspectionible, source_type: 'BridgeLikeCondition', class_name: 'BridgeCondition'

  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------  
  def latest_bridge_condition
    bridge_conditions.ordered.first
  end

  def set_calculated_condition!
    self.calculated_condition = bridge_conditions.ordered.first&.calculated_condition
    self.save
  end
end