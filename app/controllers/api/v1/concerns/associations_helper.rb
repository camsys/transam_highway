module Api::V1::Concerns::AssociationsHelper
  private 
  
  def get_associations
    unless params[:class].blank?
      if association_class_allowed?
        association_class = params[:class].safe_constantize
        if association_class
          @associations = get_class_data(association_class)
        else
          @association_class_not_found = true
        end
      else
        @association_class_not_allowed = true
      end
    else
      # list all
      @list_all = true
      @all_associations = {}
      rails_admin_highway_lookup_tables.each do |class_name|
        association_class = class_name.safe_constantize
        if association_class
          @all_associations[class_name] = get_class_data(association_class)
        end
      end
    end
  end

  def get_class_data(association_class)
    if association_class.respond_to?(:active)
      association_class.active
    else
      association_class.all
    end
  end

  def association_class_allowed?
    rails_admin_highway_lookup_tables.include?(params[:class])
  end

  def rails_admin_highway_lookup_tables
    Rails.application.config.rails_admin_highway_lookup_tables || [] 
  end 
end