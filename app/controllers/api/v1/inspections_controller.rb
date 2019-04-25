class Api::V1::InspectionsController < Api::ApiController
  before_action :get_data

  # GET /inspections
  def index
  end

  def update
    
  end

  private

  def get_data
    # sequence matters
    query_highway_structures
    query_bridges
    query_culverts
    query_inspections
    query_bridge_conditions
    query_culvert_conditions
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

    # HACK: until we have filtering by user org, we have a temporary filter here to only
    # include bridges that have inspections, to filter out all the bridge stubs we've
    # added temporarily for sprint 7
    # @highway_structure_ids = @highway_structures.pluck(:id)
    struct_ids = HighwayStructure.all.joins(:inspections).uniq.pluck(:id)
    @highway_structure_ids = params[:limit].blank? ? struct_ids : struct_ids[0, params[:limit].to_i]
    # @transam_asset_ids = @highway_structures.pluck("transam_assetible_id")
    @transam_asset_ids = HighwayStructure.where(id: @highway_structure_ids).pluck("transam_assetible_id")
  end

  def query_bridges
    @bridges = Bridge.where("highway_structures.id": @highway_structure_ids)
    @bridge_asset_ids = @bridges.pluck("transam_assetible_id")
  end

  def query_culverts
    @culverts = Culvert.where("highway_structures.id": @highway_structure_ids)
    @culvert_asset_ids = @bridges.pluck("transam_assetible_id")
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
    @bridge_conditions = BridgeCondition.where("inspections.id": @inspection_ids, "transam_asset_id": @bridge_asset_ids)
  end

  def query_culvert_conditions
    @culvert_conditions = CulvertCondition.where("inspections.id": @inspection_ids, "transam_asset_id": @culvert_asset_ids)
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
