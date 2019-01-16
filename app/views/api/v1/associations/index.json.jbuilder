if @list_all && @all_associations
  json.associations do 
    @all_associations.each do |class_name, data|
      json.set! class_name, data
    end
  end
elsif @associations
  json.set! params[:class], @associations
end