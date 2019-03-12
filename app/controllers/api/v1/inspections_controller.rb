class Api::V1::InspectionsController < Api::ApiController
  before_action :query_inspections

  # GET /inspections
  def index
  end

  private

  def query_inspections
    structure = HighwayStructure.find_by_guid(params[:structure_id])
    
    if !structure
      @status = :fail
      @data = {structure: "Structure not found."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @inspections = Inspection.where(transam_asset_id: structure.transam_asset.id)
    if params[:start_date].blank?
      @inspections = @inspections.where(Inspection.arel_table[:event_datetime].gteq(params[:start_date]))
    end
    if params[:end_date].blank?
      @inspections = @inspections.where(Inspection.arel_table[:event_datetime].lteq(params[:end_date]))
    end
  end

end
