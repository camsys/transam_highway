class ElementsController < TransamController

  before_action :set_inspection
  before_action :set_element, except: [:new, :create, :save_quantity_changes]

  # GET /inspections/:inspection_id/elements/new
  def new
    @element = Element.new
    @element.inspection = @inspection
    @assembly_types = @inspection.highway_structure.asset_type.assembly_types
  end


  # GET /inspections/:inspection_id/elements/1/edit
  def edit
    @assembly_types = @inspection.highway_structure.asset_type.assembly_types
  end

  # POST /inspections/:inspection_id/elements
  def create
    @element = Element.new(element_params)
    @element.inspection = @inspection

    if @element.save
      redirect_to inspection_path(@inspection, anchor: 'collapse-elements')
    else
      render :new
    end
  end

  # PATCH/PUT /inspections/:inspection_id/elements/1
  def update
    if @element.update(element_params)
      redirect_to inspection_path(@inspection, anchor: 'collapse-elements')
    else
      render :edit
    end
  end

  # DELETE /inspections/:inspection_id/elements/1
  def destroy
    @element.destroy
    redirect_to inspection_path(@inspection, anchor: 'collapse-elements')
  end

  def edit_comment
  end

  # both element and defect changes
  def save_quantity_changes
    unless params[:quantity_changes].blank?
      if params[:quantity_changes][:elements]
        params[:quantity_changes][:elements].each do |el_id, quantity|
          el = Element.find_by_id(el_id)
          el.update(quantity: quantity) if el
        end
      end
      if params[:quantity_changes][:defects]
        params[:quantity_changes][:defects].each do |defect_id, quan_changes|
          defect = Defect.find_by_id(defect_id)
          defect.update(quan_changes.permit(Defect.allowable_params).to_h) if defect
        end
      end
    end

    redirect_to inspection_path(@inspection, anchor: 'collapse-elements')
  end


  private
    def set_inspection
      @inspection = Inspection.find_by_object_key(params[:inspection_id])
    end

    def set_element
      @element = Element.find_by_object_key(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def element_params
      params.require(:element).permit(Element.allowable_params)
    end
end
