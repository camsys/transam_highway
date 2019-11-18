# -----------------------------------------------
#
#
# Service to handle automated creation of new inspections
#
#
# Inspections can be generated by:
# -- data import
# -- closing final inspection and opening new inspection
# -- changing scheduled inspection type settings
#
# If inspection_type_setting.calculated_inspection_due_date is given, this will be used to set generated inspection due date
# Otherwise, calculated from prev inspection
# -----------------------------------------------


class InspectionGenerator

  attr_accessor :inspection_type_setting

  def initialize(inspection_type_setting)
    self.inspection_type_setting = inspection_type_setting
  end

  def inspections
    @inspection_type_setting.highway_structure.inspections
  end

  def specific_inspections
    inspections.where(inspection_type: @inspection_type_setting.inspection_type)
  end

  def cancel
    specific_inspections.where.not(state: 'final').first.destroy if specific_inspections.where.not(state: 'final').first
  end

  def create

    is_recurring = (@inspection_type_setting.inspection_type.can_be_recurring && @inspection_type_setting.inspection_type.name != 'Special') || (@inspection_type_setting.inspection_type.name == 'Special' && @inspection_type_setting.description.present?)

    insp = if is_recurring && specific_inspections.where.not(state: 'final').count > 0
      active.update!(calculated_inspection_due_date: @inspection_type_setting.calculated_inspection_due_date) if @inspection_type_setting.calculated_inspection_due_date
      active
    elsif inspections.count > 0
      from_last
    else
      initial
    end

    insp
  end

  def initial
    typed_asset = TransamAsset.get_typed_asset(@inspection_type_setting.highway_structure)
    typed_asset.inspection_class.create(highway_structure: @inspection_type_setting.highway_structure, inspection_type: @inspection_type_setting.inspection_type, calculated_inspection_due_date: @inspection_type_setting.calculated_inspection_due_date)
  end

  def active
    Inspection.get_typed_inspection(specific_inspections.where.not(state: 'final').first)
  end

  def from_last
    old_insp = Inspection.get_typed_inspection(inspections.where(state: 'final').ordered.first)
    new_insp = old_insp.deep_clone include: {elements: :defects}, except: [:object_key, :guid, :state, :event_datetime, :weather, :temperature, :calculated_inspection_due_date, :qc_inspector_id, :qa_inspector_id, :routine_report_submitted_at, :organization_type_id, :assigned_organization_id, :inspection_team_leader_id, :inspection_team_member_id, :inspection_team_member_alt_id, {elements: [:guid, {defects: [:object_key, :guid]}]}]

    old_insp.elements.where(id: old_insp.elements.distinct.pluck(:parent_element_id)).each do |old_parent_elem|
      new_parent_elem = new_insp.elements.select{|e| e.object_key == old_parent_elem.object_key}.first
      new_insp.elements.select{|e| e.parent_element_id == old_parent_elem.id}.each do |kopy_element|
        kopy_element.parent = new_parent_elem
      end
    end
    new_insp.elements.each do |elem|
      # set inspection id for defects
      elem.defects.each do |defect|
        defect.inspection = new_insp
      end

      elem.object_key = nil
    end

    new_insp.state = 'open'

    new_insp.inspection_type = @inspection_type_setting.inspection_type
    new_insp.inspection_frequency = @inspection_type_setting.frequency_months
    if new_insp.inspection_frequency || @inspection_type_setting.inspection_type.can_be_unscheduled
      if @inspection_type_setting.calculated_inspection_due_date
        new_insp.calculated_inspection_due_date = @inspection_type_setting.calculated_inspection_due_date
      elsif specific_inspections.where(state: 'final').ordered.first.try(:calculated_inspection_due_date)
        new_insp.calculated_inspection_due_date = (specific_inspections.where(state: 'final').ordered.first.calculated_inspection_due_date + (new_insp.inspection_frequency).months).at_beginning_of_month
      end
    end

    new_insp.save!

    new_insp
  end

end