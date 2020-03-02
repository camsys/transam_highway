class RoadwaysController < TransamController
  before_action :set_roadway, only: [:show, :edit, :update, :destroy]
  before_action :set_asset, only: [:show, :edit, :update, :destroy]

  # GET /roadways
  def index
    @roadways = Roadway.all
  end

  # GET /roadways/1
  def show
  end

  # GET /roadways/new
  def new
    @asset = HighwayStructure.find_by(object_key: params[:asset])
    @roadway = Roadway.new(highway_structure: @asset)

    @adt_min_year = Date.today.year - 20
    @adt_max_year = Date.today.year
    @future_adt_min_year = Date.today.year
    @future_adt_max_year = Date.today.year + 20
  end

  # GET /roadways/1/edit
  def edit
    # handle bad data, e.g. -1, nil
    @adt_min_year = [@roadway.average_daily_traffic_year, (Date.today.year - 20)].compact.max
    @adt_max_year = Date.today.year
    @future_adt_min_year = [[Date.today.year, @roadway.future_average_daily_traffic_year].compact.min, Date.today.year - 20].max
    @future_adt_max_year = Date.today.year + 20
  end

  # POST /roadways
  def create
    @roadway = Roadway.new(roadway_params)

    if @roadway.save
      @asset = @roadway.highway_structure
      fix_indicator_if_needed
    else
      render :new
    end
  end

  # PATCH/PUT /roadways/1
  def update
    if @roadway.update(roadway_params)
      @asset.reload
      fix_indicator_if_needed
    else
      render :edit
    end
  end

  # DELETE /roadways/1
  def destroy
    @roadway.destroy
    fix_indicator_if_needed
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_roadway
      @roadway = Roadway.find_by(object_key: params[:id])
    end
    def set_asset
      @asset = @roadway.highway_structure
    end

    # Only allow a trusted parameter "white list" through.
    def roadway_params
      params.require(:roadway).permit(Roadway.allowable_params)
    end

  # Should be [1, 2] or [1, A, B] but not [1, A] or [1, 2, A]
  def fix_indicator_if_needed
    count = @asset.roadways.count
    has_one = @asset.roadways.exists?(on_under_indicator: '1')
    if (has_one && count == 2) || (count == 1)
      # If there's an A, change it to 2
      r = @asset.roadways.find_by(on_under_indicator: 'A')
      r&.update_attributes(on_under_indicator: '2')
    else
      # If there's a 2, change it to A
      r = @asset.roadways.find_by(on_under_indicator: '2')
      r&.update_attributes(on_under_indicator: 'A')
    end
  end
end
