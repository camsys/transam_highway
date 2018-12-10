class Api::V1::BridgesController < Api::ApiController
  before_action :set_bridge, only: [:show, :update, :destroy]
  
  # GET /bridges.json
  def index
    total_bridges = get_bridges
    @bridges = paginate total_bridges.page(params[:page]).per(params[:page_size])
  end

  # GET /bridges/1.json
  def show 
  end

  # POST /bridges.json
  def create
    @bridge = Bridge.new(form_params)
    @bridge.creator = current_user
    unless @bridge.save
      @status = :fail
      @message  = "Unable to upload bridge due the following error: #{@bridge.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  # PATCH/PUT /bridges/1.json
  def update
    unless @bridge.update(form_params)
      @status = :fail
      @message  = "Unable to update bridge due the following error: #{@bridge.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  # DELETE /bridges/1.json
  def destroy
    unless @bridge.destroy
      @status = :fail
      @message  = "Unable to destroy bridge due the following error: #{@bridge.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  private

  def get_bridges
    # TODO: filtering
    Bridge.all
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_bridge
    @bridge = Bridge.find_by(:object_key => params[:id])

    unless @bridge
      @status = :fail
      @data = {id: "Bridge #{params[:id]} not found."}
      render status: :not_found, json: json_response(:fail, data: @data)
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def form_params
    params.require(:bridge).permit(Bridge.allowable_params)
  end

end
