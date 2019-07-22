class RoadbedsController < TransamController
  before_action :set_roadbed, except: [:new, :create]

  def index
    @inspection = Inspection.find_by(object_key: params[:inspection_id])
    @highway_structure = @inspection.highway_structure
    @roadway = Roadway.find_by_object_key(params[:roadway_id])
    if @roadway
      @roadbeds = Roadbed.where(roadway: @roadway).order(:name, :direction)
    else
      @roadbeds = Roadbed.where(roadway: @highway_structure&.roadways).order(:name, :direction)
    end
  end

  def new
    @inspection = Inspection.find_by(object_key: params[:inspection_id])
    @highway_structure = @inspection.highway_structure
    @roadbed = Roadbed.new
  end

  def create
    @inspection = Inspection.find_by(object_key: params[:inspection_id])
    @highway_structure = @inspection&.highway_structure
    @roadbed = Roadbed.new(roadbed_params)

    if @roadbed.save
      # instantize lines
      Roadbed.create_lines @roadbed, @inspection
      @roadbeds = Roadbed.where(roadway: @highway_structure&.roadways).order(:name, :direction)
    end
  end

  def destroy
    @roadbed.destroy

    redirect_back(fallback_location: root_path)
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
