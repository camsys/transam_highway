class RoadbedsController < TransamController
  before_action :set_roadbed, except: [:new, :create]

  def index
    @roadway = Roadway.find_by_object_key(params[:roadway_id])
    if @roadway
      @roadbeds = Roadbed.where(roadway: @roadway).order(:name, :direction)
    else
      @highway_structure = HighwayStructure.find_by(object_key: params[:structure_id])
      @roadbeds = Roadbed.where(roadway: @highway_structure&.roadways).order(:name, :direction)
    end
  end

  def new
    @inspection = Inspection.find_by(object_key: params[:inspection_id])
    @highway_structure = @inspection.highway_structure
    @roadbed = Roadbed.new
  end

  def create
    @roadbed = Roadbed.new(roadbed_params)

    if !@roadbed.save
      render :new
    end

    # instantize lines
    @inspection = Inspection.find_by(object_key: params[:inspection_id])
    Roadbed.create_lines @roadbed, @inspection

    @highway_structure = @inspection&.highway_structure
    @roadbeds = Roadbed.where(roadway: @highway_structure&.roadways).order(:name, :direction)
  end

  def destroy
    @roadbed.destroy
  end

  def save_vertical_clearance_changes
    unless params[:vertical_clearance_changes].blank?
      params[:vertical_clearance_changes].each do |line_id, changes|
        line = RoadbedLine.find_by_id(line_id)
        if line
          line.update(changes.permit(RoadbedLine.allowable_params).to_h) if line
        end
      end
    end

    redirect_back(fallback_location: root_path)
  end

  private
    def set_roadbed
      @roadbed = Roadbed.find_by_object_key(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def roadbed_params
      params.require(:roadbed).permit(Roadbed.allowable_params)
    end
end
