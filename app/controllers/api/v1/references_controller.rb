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
    get_highway_structures
  end

  def get_highway_structures
    # TODO: filtering
    total_highway_structures = HighwayStructure.all
    @highway_structures = paginate total_highway_structures.page(params[:page]).per(params[:page_size])
  end

end
