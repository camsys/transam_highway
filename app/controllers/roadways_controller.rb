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
    @adt_min_year = @roadway.average_daily_traffic_year
    @adt_max_year = Date.today.year
    @future_adt_min_year = [Date.today.year, @roadway.future_average_daily_traffic_year].min
    @future_adt_max_year = Date.today.year + 20
  end

  # POST /roadways
  def create
    @roadway = Roadway.new(roadway_params)

    if @roadway.save
      @asset = @roadway.highway_structure
    else
      render :new
    end
  end

  # PATCH/PUT /roadways/1
  def update
    if @roadway.update(roadway_params)
      @asset.reload
    else
      render :edit
    end
  end

  # DELETE /roadways/1
  def destroy
    @roadway.destroy
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
end
