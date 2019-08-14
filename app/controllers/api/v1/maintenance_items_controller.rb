class Api::V1::MaintenanceItemsController < Api::ApiController
  before_action :query_maintenance_items

  # GET /maintenance_items
  def index
  end

  private

  def query_maintenance_items
    inspection = Inspection.find_by_guid(params[:inspection_id])
    structure = HighwayStructure.find_by_guid(params[:structure_id])
    if !structure && !inspection
      @status = :fail
      @data = {structure: "Structure or inspection should be provided."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @maintenance_items = MaintenanceServiceOrder.all
    @maintenance_items = @maintenance_items.where(transam_asset_id: inspection.transam_asset_id) if inspection
    @maintenance_items = @maintenance_items.where(transam_asset: structure) if structure
  end

end