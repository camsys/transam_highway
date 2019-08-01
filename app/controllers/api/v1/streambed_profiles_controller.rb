class Api::V1::StreambedProfilesController < Api::ApiController
  before_action :query_streambed_profiles

  # GET /streambed_profiles.json
  def index
  end

  private

  def query_streambed_profiles
    inspection = Inspection.find_by_guid(params[:inspection_id])
    structure = HighwayStructure.find_by_guid(params[:structure_id])
    if !structure && !inspection
      @status = :fail
      @data = {structure: "Structure or inspection should be provided."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @profiles = StreambedProfile.all
    @profiles = @profiles.where(inspection_id: inspection.id) if inspection
    @profiles = @profiles.joins(:highway_structure).where(highway_structures: {id: structure.id}) if structure
  end

end
