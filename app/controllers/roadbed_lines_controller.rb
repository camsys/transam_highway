class RoadbedLinesController < TransamController
  def index
    @roadbed = Roadbed.find_by_object_key(params[:roadbed_id])
    @inspection = Inspection.find_by_object_key(params[:inspection_id])
  end
end
