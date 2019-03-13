class Api::V1::ReferencesController < Api::ApiController
  include Api::V1::Concerns::AssociationsHelper
  before_action :get_data

  # Given association class, return all data
  # GET /associations
  def index
  end

  private

  def get_data
    get_associations
    query_highway_structures
    query_element_definitions
    query_defect_definitions
    query_element_defect_definitions
  end

  def query_highway_structures
    # TODO: filtering
    @highway_structures = HighwayStructure.all

    # TODO: pagination
    #@highway_structures = paginate total_highway_structures.page(params[:page]).per(params[:page_size])

    unless params[:limit].blank?
      @highway_structures = @highway_structures.limit(params[:limit])
    end
  end

  def query_element_definitions
    @element_definitions = ElementDefinition.where(id: @highway_structures.joins(elements: :element_definition).pluck("element_definitions.id").uniq)
  end

  def query_defect_definitions
    @defect_definitions = DefectDefinition.where(id: @highway_structures.joins(defects: :defect_definition).pluck("defect_definitions.id").uniq)
  end

  def query_element_defect_definitions
    @element_defect_definitions = Defect.joins(:defect_definition, inspection: :highway_structure, element: :element_definition)
                    .where("inspections.transam_asset_id": @highway_structures.pluck("transam_assets.id"))
                    .pluck("element_definitions.id", "defect_definitions.id")
                    .each{|r| {element_definition_id: r[0], defect_definition_id: r[1]}}
  end

end
