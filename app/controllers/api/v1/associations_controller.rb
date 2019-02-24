class Api::V1::AssociationsController < Api::ApiController
  include Api::V1::Concerns::AssociationsHelper
  before_action :query_associations

  # Given association class, return all data
  # GET /associations
  def index
  end

  private

  def query_associations
    get_associations
    
    if @association_class_not_found
      @status = :fail
      @data = {class: "Class #{params[:class]} not found."}
      render status: :not_found, json: json_response(:fail, data: @data)
    elsif @association_class_not_allowed
      @status = :fail
      @data = {class: "Class #{params[:class]} not allowed."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end
  end

end
