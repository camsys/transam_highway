module HighwayFormatHelper
  def html_rjust(obj, int, padstr='&nbsp')
    obj.to_s.rjust(int).gsub(/ /, padstr)
  end

  def reference_label(table_name, field_name, default_label)
    FieldReference.get_label(table_name, field_name) || default_label 
  end
end