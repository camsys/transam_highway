class InspectionsController < TransamController
  add_breadcrumb "Home", :root_path

  before_action :set_inspection, only: [:show, :edit, :update, :destroy, :allowed_to_finalize]

  INDEX_KEY_LIST_VAR    = "inspection_key_list_cache_var"
  INSPECTION_SEARCH_PROXY_CACHE_VAR    = "inspection_proxy_cache_var"

  # GET /inspections
  def index
    #---------------------------------------------------------------------------
    # Set up any view vars needed to set the search context
    #---------------------------------------------------------------------------
    if params[:inspection_proxy].present?
      perform_search
    else
      setup_inspection_search_vars
    end

    respond_to do |format|
      format.html
      format.json {
        render :json => {
          :total => @total_count,
          :rows =>  index_rows_as_json
        }
      }
    end
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

  def allowed_to_finalize

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
    respond_to do |format|
      if @inspection.update!(typed_inspection_params(@inspection))

        # do any automatic workflow transitions that are allowed
        (Inspection.automatic_transam_workflow_transitions && @inspection.allowable_events).each do |transition|
          if @inspection.machine.fire_state_event(transition)
            WorkflowEvent.create(creator: current_user, accountable: @inspection, event_type: transition)
          end
        end
        notify_user(:notice, "Inspection was successfully updated.")
        format.html { redirect_to inspection_path(@inspection.object_key) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @inspection.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /inspections/1
  def destroy
    @inspection.destroy
    redirect_to inspections_url, notice: 'Inspection was successfully destroyed.'
  end

  #-----------------------------------------------------------------------------
  # Reset the search, this clears out the search params and sets the defaults
  # for the current user
  #-----------------------------------------------------------------------------
  # GET /inspections/reset
  def reset
    clear_cached_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR)
    cache_list([], INDEX_KEY_LIST_VAR)

    redirect_to params[:redirect_to] || inspections_path, status: 303
  end

  # POST /inspections/new_search
  def new_search
    perform_search

    respond_to do |format|
      format.js
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inspection
      @inspection = Inspection.get_typed_inspection(Inspection.find_by(object_key: params[:id]))
      @asset = TransamAsset.get_typed_asset(@inspection.highway_structure)
    end

    # Only allow a trusted parameter "white list" through.
    def inspection_params
      params.require(:inspection).permit(Inspection.allowable_params)
    end

    def typed_inspection_params(inspection)
      params.require(:inspection).permit(inspection.allowable_params)
    end

    def inspection_proxy_form_params
      params.require(:inspection_proxy).permit(InspectionProxy.allowable_params)
    end

    #-----------------------------------------------------------------------------
    # Perform a new search for inspections
    #-----------------------------------------------------------------------------
    def perform_search
      @search_proxy = InspectionProxy.new(inspection_proxy_form_params)
      # Make sure we flag this as not being a new search so the results table will
      # not be hidden
      @search_proxy.new_search = '0'

      # Run the search query
      run_searcher

      # cache the search results
      cache_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR, @search_proxy)

      Rails.logger.debug "Rows returned = #{@total_count}"
    end

    #-----------------------------------------------------------------------------
    # Initializes the search variables @search_proxy
    #-----------------------------------------------------------------------------
    def setup_inspection_search_vars
      #---------------------------------------------------------------------------
      # Reload the last search or initialize a new one
      #---------------------------------------------------------------------------
      @search_proxy = get_cached_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR)
      if @search_proxy.blank?
        @search_proxy = InspectionProxy.new
        # Flag this as a new search so the search results will be hidden
        @search_proxy.new_search = '1'
        # Set default state filters
        @search_proxy.state = Inspection.state_names - ['final'] unless @search_proxy.state
        @search_proxy.structure_status_type_code = [StructureStatusType.find_by_name('Active').try(:code)] unless @search_proxy.structure_status_type_code

        cache_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR, @search_proxy)
      end

      #---------------------------------------------------------------------------
      # cache the search proxy
      #---------------------------------------------------------------------------
      Rails.logger.debug @search_proxy.inspect

      #---------------------------------------------------------------------------
      # Run the query, this sets @errors and search results
      #---------------------------------------------------------------------------
      run_searcher
    end

    def run_searcher
      @searcher = InspectionSearcher.new({user: current_user, search_proxy: @search_proxy, can_view_all: can?(:view_all, Inspection)})
      @inspections = @searcher.data
      @total_count = @inspections.count
    end

    def index_rows_as_json
      params[:sort] ||= 'inspections.object_key'

      multi_sort = params[:multiSort]
      unless (multi_sort.nil?)
        sorting_string = ""

        multi_sort.each { |x|
          sorting_string = sorting_string + "#{x[0]}: :#{x[1]}"
        }

      else
        sorting_string = "#{params[:sort]} #{params[:order]}"
      end
      cache_list(@inspections.order(sorting_string), INDEX_KEY_LIST_VAR)
      @inspections.order(sorting_string).limit(params[:limit]).offset(params[:offset]).as_json
    end
end
