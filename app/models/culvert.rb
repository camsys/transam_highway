class Culvert < BridgeLike

  has_many :culvert_conditions, through: :inspections, source: :inspectionible, source_type: 'BridgeLikeCondition', class_name: 'CulvertCondition'

  default_scope { where(asset_subtype: AssetSubtype.joins(:asset_type).where(asset_types: {class_name: 'Culvert'})) }
  #-----------------------------------------------------------------------------
  #
  # Instance Methods
  #
  #-----------------------------------------------------------------------------  
  def latest_culvert_condition
    culvert_conditions.ordered.first
  end

  def set_calculated_condition!
    self.calculated_condition = latest_culvert_condition&.calculated_condition || 'unknown'
    self.save
  end
end
