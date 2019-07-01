class StreambedProfilesController < ApplicationController
  before_action :set_inspection
  before_action :set_streambed_profile, only: [:edit, :update, :destroy]

  def index
    @streambed_profiles = @inspection.streambed_profiles
  end

  # GET /streambed_profiles/new
  def new
    @streambed_profile = @inspection.streambed_profiles.build
  end

  # GET /streambed_profiles/1/edit
  def edit
  end

  # POST /streambed_profiles
  def create
    @streambed_profile = @inspection.streambed_profiles.build(streambed_profile_params)

    if @streambed_profile.save
      redirect_to @streambed_profile, notice: 'Streambed profile was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /streambed_profiles/1
  def update

    if @streambed_profile.update(streambed_profile_params)

      if params[:targets]
        params[:targets].each do |target, val|
          profile_point = @streambed_profile.streambed_profile_points.find_by(object_key: target)
          profile_point.update(value: val) unless profile_point.nil?
        end
      end

      #redirect_to @streambed_profile, notice: 'Streambed profile was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /streambed_profiles/1
  def destroy
    @streambed_profile.destroy
    redirect_to streambed_profiles_url, notice: 'Streambed profile was successfully destroyed.'
  end

  private

    def set_inspection
      @inspection = Inspection.get_typed_inspection(Inspection.find_by(object_key: params[:inspection_id]))
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_streambed_profile
      @streambed_profile = StreambedProfile.find_by(object_key: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def streambed_profile_params
      params.require(:streambed_profile).permit(StreambedProfile.allowable_params)
    end
end
