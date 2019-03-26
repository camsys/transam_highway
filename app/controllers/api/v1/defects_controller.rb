class Api::V1::DefectsController < Api::ApiController
  before_action :query_defects

  # GET /defects
  def index
  end

  private

  def query_defects
    inspection = Inspection.find_by_guid(params[:inspection_id])
    structure = HighwayStructure.find_by_guid(params[:structure_id])
    if !structure && !inspection
      @status = :fail
      @data = {structure: "Structure or inspection should be provided."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @defects = Defect.all
    @defects = @defects.where(inspection_id: inspection.id) if inspection
    @defects = @defects.joins(:highway_structure).where(highway_structures: {id: structure.id}) if structure
    
    element = Element.find_by_guid(params[:element_id])
    @defects = @defects.where(element_id: element.id) if element
  end

end
