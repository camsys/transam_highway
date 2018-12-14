class Api::V1::HighwayStructuresController < Api::ApiController
  before_action :set_highway_structure, only: [:show, :update, :destroy]
  
  # GET /highway_structures.json
  def index
    total_highway_structures = get_highway_structures
    @highway_structures = paginate total_highway_structures.page(params[:page]).per(params[:page_size])
  end

  # GET /highway_structures/1.json
  def show 
  end

  # POST /highway_structures.json
  def create
    @highway_structure = HighwayStructure.new(form_params)
    unless @highway_structure.save
      @status = :fail
      @message  = "Unable to upload highway structure due the following error: #{@highway_structure.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  # PATCH/PUT /highway_structures/1.json
  def update
    unless @highway_structure.update(form_params)
      @status = :fail
      @message  = "Unable to update highway structure due the following error: #{@highway_structure.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  # DELETE /highway_structures/1.json
  def destroy
    unless @highway_structure.destroy
      @status = :fail
      @message  = "Unable to destroy highway structure due the following error: #{@highway_structure.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  private

  def get_highway_structures
    # TODO: filtering
    HighwayStructure.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_highway_structure
    @highway_structure = HighwayStructure.find_by(:object_key => params[:id])

    unless @highway_structure
      @status = :fail
      @data = {id: "Highway structure #{params[:id]} not found."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def form_params
    params.require(:highway_structure).permit(HighwayStructure.allowable_params)
  end

end
