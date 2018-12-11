class Api::V1::AssociationsController < Api::ApiController
  before_action :get_associations

  # Given association class, return all data
  # GET /associations
  def index
  end

  private

  def get_associations
    unless params[:class].blank?
      if association_class_allowed?
        association_class = params[:class].safe_constantize
        if association_class
          if association_class.respond_to?(:active)
            @associations = association_class.active
          else
            @associations = association_class.all
          end
        else
          not_found = true
        end
      else
        not_allowed = true
      end
    else
      not_found = true
    end

    if not_found
      @status = :fail
      @data = {class: "Class #{params[:class]} not found."}
      render status: :not_found, json: json_response(:fail, data: @data)
    elsif not_allowed
      @status = :fail
      @data = {class: "Class #{params[:class]} not allowed."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end
  end

  def association_class_allowed?
    rails_admin_highway_lookup_tables = Rails.application.config.rails_admin_highway_lookup_tables || []

    rails_admin_highway_lookup_tables.include?(params[:class])
  end

end
