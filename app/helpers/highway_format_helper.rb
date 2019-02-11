module HighwayFormatHelper
  def html_rjust(obj, int, padstr='&nbsp')
    obj.to_s.rjust(int).gsub(/ /, padstr)
  end

end