class StreambedProfilesController < ApplicationController
  before_action :set_streambed_profile, only: [:edit, :update, :destroy]

  def index
    @streambed_profiles = StreambedProfile.all
  end

  # GET /streambed_profiles/new
  def new
    @streambed_profile = StreambedProfile.new

    @streambed_profile.transam_asset_id = BridgeLike.find_by(object_key: params[:transam_asset_id]).id if params[:transam_asset_id]

    existing_profile_years = @streambed_profile.bridge_like&.streambed_profiles&.map{|p| p.year}

    @years = @streambed_profile.bridge_like&.inspections&.select{|i| i.state == "final"}&.map{|i| i.calculated_inspection_due_date.year}&.select{|y| !existing_profile_years.include?(y)}&.sort&.reverse
  end

  # GET /streambed_profiles/1/edit
  def edit
  end

  # POST /streambed_profiles
  def create
    @streambed_profile = StreambedProfile.new(streambed_profile_params)

    if @streambed_profile.save
      redirect_to inventory_path(@streambed_profile.bridge_like.object_key), notice: 'Streambed profile was successfully created.'
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
          if profile_point.nil?
            @streambed_profile.streambed_profile_points.create(distance: target, value: val)
          else
            profile_point.update(value: val)
          end
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

  def new_distance

  end

  def update_many
    if params[:targets]
      params[:targets].each do |target, points|
        streambed_profile = StreambedProfile.find_by(object_key: target)

        if streambed_profile
          points.each do |point, val|
            profile_point = streambed_profile.streambed_profile_points.find_by(object_key: point)
            if profile_point.nil?
              streambed_profile.streambed_profile_points.create(distance: point, value: val)
            else
              profile_point.update(value: val)
            end
          end
        end


      end
    end

    if params[:water_levels]
      params[:water_levels].each do |target, water_level|
        streambed_profile = StreambedProfile.find_by(object_key: target)
        streambed_profile.update(water_level: water_level) if streambed_profile
      end
    end
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_streambed_profile
      @streambed_profile = StreambedProfile.find_by(object_key: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def streambed_profile_params
      params.require(:streambed_profile).permit(StreambedProfile.allowable_params)
    end
end
