class Api::V1::InspectionsController < Api::ApiController
  before_action :get_data

  # GET /inspections
  def index
  end

  private

  def get_data
    # sequence matters
    query_highway_structures
    query_bridges
    query_inspections
    query_bridge_conditions
    query_elements
    query_defects
    query_roadways
    query_images
    query_documents
  end

  def query_highway_structures
    @highway_structures = HighwayStructure.all
    unless params[:limit].blank?
      @highway_structures = @highway_structures.limit(params[:limit])
    end

    @highway_structure_ids = @highway_structures.pluck(:id)
    @transam_asset_ids = @highway_structures.pluck("transam_assetible_id")
  end

  def query_bridges
    @bridges = Bridge.where("highway_structures.id": @highway_structure_ids)
  end

  def query_inspections
    @inspections = Inspection.where(transam_asset_id: @transam_asset_ids)
    unless params[:start_date].blank?
      @inspections = @inspections.where(Inspection.arel_table[:event_datetime].gteq(params[:start_date]))
    end
    unless params[:end_date].blank?
      @inspections = @inspections.where(Inspection.arel_table[:event_datetime].lteq(params[:end_date]))
    end

    @inspection_ids = @inspections.pluck(:id)
  end

  def query_bridge_conditions
    @bridge_conditions = BridgeCondition.where("inspections.id": @inspection_ids)
  end

  def query_elements
    @elements = Element.where(inspection_id: @inspection_ids)
  end

  def query_defects
    @defects = Defect.where(inspection_id: @inspection_ids)
  end

  def query_roadways
    @roadways = Roadway.where(transam_asset_id: @transam_asset_ids)
  end

  def query_images
    @images = Image.where(imagable_type: 'TransamAsset', imagable_id: @transam_asset_ids)
  end

  def query_documents
    @documents = Document.where(documentable_type: 'TransamAsset', documentable_id: @transam_asset_ids)
  end


end
