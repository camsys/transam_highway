associations = [:inspection_type]
associations.each do |asso|
  json.(inspection_type_setting, "#{asso}_id")
  json.set! asso, inspection_type_setting.try(asso).try(:name)
end

json.(inspection_type_setting, :object_key, :is_required, :frequency_months, :description)