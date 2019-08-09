class Api::V1::RoadbedsController < Api::ApiController
  before_action :query_roadbeds

  # GET /roadbeds
  def index
  end

  private

  def query_roadbeds
    roadway = Roadway.find_by_guid(params[:roadway_id])
    if !roadway
      @status = :fail
      @data = {structure: "Roadway should be provided."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @roadbeds = Roadbed.where(roadway: roadway)
  end

end
