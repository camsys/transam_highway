class Api::V1::ElementsController < Api::ApiController
  before_action :query_elements

  # GET /elements
  def index
  end

  private

  def query_elements
    inspection = Inspection.find_by_guid(params[:inspection_id])
    structure = HighwayStructure.find_by_guid(params[:structure_id])
    if !structure && !inspection
      @status = :fail
      @data = {structure: "Structure or inspection should be provided."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @elements = Element.all
    @elements = @elements.where(inspection_id: inspection.id) if inspection
    @elements = @elements.joins(:highway_structure).where(highway_structures: {id: structure.id}) if structure
  end

end
