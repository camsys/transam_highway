class Api::V1::CulvertsController < Api::ApiController
  before_action :set_culvert, only: [:show, :update, :destroy]
  
  # GET /culverts.json
  def index
    total_culverts = get_culverts
    @culverts = paginate total_culverts.page(params[:page]).per(params[:page_size])
  end

  # GET /culverts/1.json
  def show 
  end

  # POST /culverts.json
  def create
    @culvert = culvert.new(new_form_params)
    unless @culvert.save
      @status = :fail
      @message  = "Unable to upload culvert due the following error: #{@culvert.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  # PATCH/PUT /culverts/1.json
  def update
    unless @culvert.update(form_params)
      @status = :fail
      @message  = "Unable to update culvert due the following error: #{@culvert.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  # DELETE /culverts/1.json
  def destroy
    unless @culvert.destroy
      @status = :fail
      @message  = "Unable to destroy culvert due the following error: #{@culvert.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  private

  def get_culverts
    # TODO: filtering
    culvert.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_culvert
    @culvert = culvert.find_by(:object_key => params[:id])

    unless @culvert
      @status = :fail
      @data = {id: "culvert #{params[:id]} not found."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def form_params
    params.require(:culvert).permit(HighwayStructure.allowable_params + culvert.allowable_params)
  end

  def new_form_params
    params.require(:culvert).permit(Asset.allowable_params)
  end

end
