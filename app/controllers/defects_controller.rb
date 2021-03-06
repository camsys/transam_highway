class DefectsController < TransamController

  before_action :set_inspection_element
  before_action :set_defect, except: [:new, :create]

  # GET /inspections/:inspection_id/elements/:element_id/defects/new
  def new
    @defect = Defect.new
  end

  # GET /inspections/:inspection_id/elements/:element_id/defects/1/edit
  def edit
  end

  # POST /inspections/:inspection_id/defects
  def create
    @defect = Defect.new(defect_params)
    @defect.element = @element
    @defect.inspection = @inspection

    if @defect.save
      @inspection = Inspection.get_typed_inspection(@inspection)
    else
      render :new
    end
  end

  # PATCH/PUT /inspections/:inspection_id/elements/:element_id/defects/1
  def update
    if @defect.update(defect_params)
      @inspection = Inspection.get_typed_inspection(@inspection)
    else
      render :edit
    end
  end

  # DELETE /inspections/:inspection_id/elements/:element_id/defects/1
  def destroy
    @defect.destroy
    @inspection = Inspection.get_typed_inspection(@inspection)
  end

  def edit_comment
  end


  private
    def set_inspection_element
      @inspection = Inspection.find_by_object_key(params[:inspection_id])
      @element = Element.find_by_object_key(params[:element_id])
    end

    def set_defect
      @defect = Defect.find_by_object_key(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def defect_params
      params.require(:defect).permit(Defect.allowable_params)
    end
end
