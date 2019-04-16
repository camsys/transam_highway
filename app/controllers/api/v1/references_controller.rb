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
    @element_definitions = ElementDefinition.all
  end

  def query_defect_definitions
    @defect_definitions = DefectDefinition.all
  end

  def query_element_defect_definitions
    @element_defect_definitions = DefectDefinitionsElementDefinition.all
  end

end
