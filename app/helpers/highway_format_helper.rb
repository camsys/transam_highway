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
end