class Api::V1::ElementDefinitionsController < Api::ApiController
  before_action :query_definitions

  # GET /element_definitions
  def index
  end

  private

  def query_definitions
    @element_definitions = ElementDefinition.all
  end

end
