class ElementsController < TransamController

  before_action :set_inspection
  before_action :set_element, except: [:new, :create]

  # GET /inspections/:inspection_id/elements/new
  def new
    @element = Element.new
    @element.inspection = @inspection
  end


  # GET /inspections/:inspection_id/elements/1/edit
  def edit
  end

  # POST /inspections/:inspection_id/elements
  def create
    @element = Element.new(element_params)
    @element.inspection = @inspection

    if @element.save
      redirect_to @inspection, notice: 'Element was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /inspections/:inspection_id/elements/1
  def update
    if @element.update(element_params)
      redirect_to @inspection, notice: 'Element was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /inspections/:inspection_id/elements/1
  def destroy
    @element.destroy
    redirect_to @inspection, notice: 'Element was successfully destroyed.'
  end

  def edit_comment
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
