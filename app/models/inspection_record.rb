class InspectionRecord < ActiveRecord::Base
  self.abstract_class = true

  def allowable_params
    arr = self.class::FORM_PARAMS.dup

    if self.class.superclass.name != "InspectionRecord"
      arr << self.class.superclass::FORM_PARAMS
    end

    a = self.class.try(:acting_as_model)
    while a.present?
      arr << a::FORM_PARAMS.dup
      a = a.try(:acting_as_model)
    end

    return arr.flatten
  end

end