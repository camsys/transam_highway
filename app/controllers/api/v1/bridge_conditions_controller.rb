class Api::V1::BridgeConditionsController < Api::ApiController
  before_action :query_bridge_conditions

  # GET /bridge_like_conditions
  def index
  end

  private

  def query_bridge_conditions
    structure = HighwayStructure.find_by_guid(params[:structure_id])
    
    if !structure
      @status = :fail
      @data = {structure: "Structure not found."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @bridge_like_conditions = BridgeLikeCondition.where(transam_asset_id: structure.transam_asset.id)
    unless params[:start_date].blank?
      @bridge_like_conditions = @bridge_like_conditions.where(Inspection.arel_table[:event_datetime].gteq(params[:start_date]))
    end
    unless params[:end_date].blank?
      @bridge_like_conditions = @bridge_like_conditions.where(Inspection.arel_table[:event_datetime].lteq(params[:end_date]))
    end
  end

end
