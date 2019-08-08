class Api::V1::RoadbedLinesController < Api::ApiController
  before_action :query_roadbed_lines

  # GET /roadbed_lines
  def index
  end

  private

  def query_roadbed_lines
    inspection = Inspection.find_by_guid(params[:inspection_id])
    if !inspection
      @status = :fail
      @data = {structure: "Inspection should be provided."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @roadbeds = Roadbed.where(inspection: inspection)
  end

end
