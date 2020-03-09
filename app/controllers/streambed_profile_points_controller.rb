class StreambedProfilePointsController < ApplicationController
  before_action :set_streambed_profile
  before_action :set_inspection
  before_action :set_asset
  before_action :set_streambed_profile_point, only: [:show, :edit, :update, :destroy]

  # GET /streambed_profile_points
  def index
    @streambed_profile_points = @streambed_profile.streambed_profile_points
  end

  # GET /streambed_profile_points/1
  def show
  end

  # GET /streambed_profile_points/new
  def new
    @streambed_profile_point = StreambedProfilePoint.new

  end

  # GET /streambed_profile_points/1/edit
  def edit

  end

  # POST /streambed_profile_points
  def create
    @streambed_profile_point = StreambedProfilePoint.new(streambed_profile_point_params)
    @streambed_profile_point.streambed_profile = @streambed_profile

    if @streambed_profile_point.save
      @inspection = Inspection.get_typed_inspection @inspection
    else
      render :new
    end
  end

  # PATCH/PUT /streambed_profile_points/1
  def update
    if @streambed_profile_point.update(streambed_profile_point_params)
      @inspection = Inspection.get_typed_inspection @inspection
      #redirect_to @streambed_profile_point, notice: 'Streambed profile point was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /streambed_profile_points/1
  def destroy
    @inspection = Inspection.get_typed_inspection @inspection
    @streambed_profile_point.destroy
  end

  private
    def set_streambed_profile
      @streambed_profile = StreambedProfile.find_by(object_key: params[:streambed_profile_id])
    end

    def set_inspection
      @inspection = @streambed_profile.inspection
    end

    def set_asset
      @asset = TransamAsset.get_typed_asset @streambed_profile.bridge_like
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_streambed_profile_point
      @streambed_profile_point = StreambedProfilePoint.find_by(object_key: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def streambed_profile_point_params
      params.require(:streambed_profile_point).permit(StreambedProfilePoint.allowable_params)
    end
end
