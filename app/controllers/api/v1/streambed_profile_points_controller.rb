class Api::V1::StreambedProfilePointsController < Api::ApiController
  before_action :query_streambed_profile_points

  # GET /streambed_profiles.json
  def index
  end

  private

  def query_streambed_profile_points
    profile = StreambedProfile.find_by_guid(params[:profile_id])
    if !profile
      @status = :fail
      @data = {structure: "Streambed profile should be provided."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end

    @profile_points = StreambedProfilePoint.where(streambed_profile: profile)
  end

end
