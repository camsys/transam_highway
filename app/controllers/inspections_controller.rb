class InspectionsController < ApplicationController
  add_breadcrumb "Home", :root_path

  before_action :set_inspection, only: [:show, :edit, :update, :destroy]

  # GET /inspections
  def index
    @inspections = Inspection.all
  end

  # GET /inspections/1
  def show
    add_breadcrumb "#{@asset.asset_type.name}".pluralize,
                   inventory_index_path(:asset_type => @asset.asset_type, :asset_subtype => 0)
    add_breadcrumb @asset, inventory_path(@asset)
    add_breadcrumb "#{view_context.format_as_date(@inspection.event_datetime)} Inspection"
  end

  # GET /inspections/new
  def new
    @inspection = Inspection.new
  end

  # GET /inspections/1/edit
  def edit
  end

  # POST /inspections
  def create
    @inspection = Inspection.new(inspection_params)

    if @inspection.save
      redirect_to @inspection, notice: 'Inspection was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /inspections/1
  def update
    if @inspection.update(inspection_params)
      redirect_to @inspection, notice: 'Inspection was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /inspections/1
  def destroy
    @inspection.destroy
    redirect_to inspections_url, notice: 'Inspection was successfully destroyed.'
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inspection
      @inspection = Inspection.find_by(object_key: params[:id]).specific
      @asset = @inspection.highway_structure
    end

    # Only allow a trusted parameter "white list" through.
    def inspection_params
      params.require(:inspection).permit(Inspection.allowable_params)
    end
end
