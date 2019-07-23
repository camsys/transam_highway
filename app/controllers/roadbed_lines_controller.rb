class RoadbedLinesController < TransamController
  def index
    @roadbed = Roadbed.find_by_object_key(params[:roadbed_id])
  end
end
