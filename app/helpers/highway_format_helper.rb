module HighwayFormatHelper
  def html_rjust(obj, int, padstr='&nbsp')
    obj.to_s.rjust(int).gsub(/ /, padstr)
  end

  def reference_label(table_name, field_name, default_label)
    FieldReference.get_label(table_name, field_name) || default_label
  end

  def suppress_values(value, suppress_all_zeroes: true, suppress_list: [-1, '-1', '_'], &block)
    if (suppress_all_zeroes && value.to_i == 0) || suppress_list.include?(value)
      '-'
    else
      block_given? ? yield(value) : value
    end
  end

  def format_for_pdf_printing(datetime)
    datetime.strftime(" %m/%d/%Y @ %k:%M")
  end

  def defect_location_new_or_edit_path(defect, condition_state)
    if defect.defect_locations.find_by(condition_state: condition_state)
      edit_inspection_element_defect_defect_location_path(defect.inspection, defect.element,
                                                          defect, defect.defect_locations.find_by(condition_state: condition_state),
                                                          condition_state: condition_state)
    else
      new_inspection_element_defect_defect_location_path(defect.inspection, defect.element,
                                                         defect, condition_state: condition_state)
    end
  end
end
