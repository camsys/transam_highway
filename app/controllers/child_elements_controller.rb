class ChildElementsController < TransamController

  before_action :set_inspection_element
  before_action :set_child_element, except: [:new, :create]

  # GET /inspections/:inspection_id/elements/new
  def new
    @child_element = Element.new
  end

  # GET /inspections/:inspection_id/elements/1/edit
  def edit
  end

  # POST /inspections/:inspection_id/elements
  def create
    @child_element = Element.new(element_params)
    @child_element.parent = @element
    @child_element.inspection = @inspection

    if @child_element.save
      redirect_to inspection_path(@inspection, anchor: 'collapse-elements')
    else
      render :new
    end
  end

  # PATCH/PUT /inspections/:inspection_id/elements/1
  def update
    if @child_element.update(element_params)
      redirect_to inspection_path(@inspection, anchor: 'collapse-elements')
    else
      render :edit
    end
  end

  # DELETE /inspections/:inspection_id/elements/1
  def destroy
    @child_element.destroy
    redirect_to inspection_path(@inspection, anchor: 'collapse-elements')
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inspection_element
      @inspection = Inspection.find_by_object_key(params[:inspection_id])
      @element = Element.find_by_object_key(params[:element_id])
    end

    def set_child_element
      @child_element = Element.find_by_object_key(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def element_params
      params.require(:element).permit(Element.allowable_params)
    end
end
