class DefectLocationsController < ApplicationController
  before_action :set_inspection_element_defect
  before_action :set_defect_location, except: [:new, :create]

  # GET /inspections/:inspection_id/elements/:element_id/defects/:defect_id/defect_locations/new
  def new
    @defect_location = DefectLocation.new
  end

  # GET /defect_locations/1/edit
  def edit
  end

  # POST /defect_locations
  def create
    @defect_location = DefectLocation.new(defect_location_params)
    @defect_location.defect = @defect

    image_file = params[:defect_location][:image]

    image = create_image(image_file) if image_file

    if @defect_location.save
      @inspection = Inspection.get_typed_inspection(@inspection)
      # redirect_to @defect_location, notice: 'Defect location was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /defect_locations/1
  def update
    image_file = params[:defect_location][:image]

    if image_file
      # Replace any existing images
      @defect_location.images.destroy_all

      image = create_image(image_file)
    end

    if @defect_location.update(defect_location_params)
      @inspection = Inspection.get_typed_inspection(@inspection)
      # redirect_to @defect_location, notice: 'Defect location was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /defect_locations/1
  def destroy
    @defect_location.destroy
    @inspection = Inspection.get_typed_inspection(@inspection)
    # redirect_to defect_locations_url, notice: 'Defect location was successfully destroyed.'
  end

  private
    def set_inspection_element_defect
      @inspection = Inspection.find_by(object_key: params[:inspection_id])
      @element = Element.find_by(object_key: params[:element_id])
      @defect = Defect.find_by(object_key: params[:defect_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_defect_location
      @defect_location = DefectLocation.find_by(object_key: params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def defect_location_params
      params.require(:defect_location).permit(DefectLocation.allowable_params)
    end

  def create_image(image_file)
    Image.create(image: image_file,
                 global_base_imagable: params[:defect_location][:global_base_imagable],
                 imagable: @defect_location,
                 image_classification: ImageClassification.find_by(name: 'DefectLocation'),
                 description: @defect_location.to_s.truncate(100, separator: ' '),
                 exportable: params[:defect_location][:exportable],
                 creator: current_user)
  end
end
