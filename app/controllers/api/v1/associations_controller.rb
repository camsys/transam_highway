class Api::V1::AssociationsController < Api::ApiController
  before_action :get_associations

  # Given association class, return all data
  # GET /associations
  def index
  end

  private

  def get_associations
    unless params[:class].blank?
      association_class = params[:class].safe_constantize
      if association_class
        if association_class.respond_to?(:active)
          @associations = association_class.active
        else
          @associations = association_class.all
        end
      end
    end

    unless association_class
      @status = :fail
      @data = {class: "Class #{params[:class]} not found."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end
  end

end
