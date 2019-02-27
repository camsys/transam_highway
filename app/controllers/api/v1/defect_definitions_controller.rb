class Api::V1::DefectDefinitionsController < Api::ApiController
  before_action :query_definitions

  # GET /defect_definitions
  def index
  end

  private

  def query_definitions
    @defect_definitions = DefectDefinition.all
  end

end
