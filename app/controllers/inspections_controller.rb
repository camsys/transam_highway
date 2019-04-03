class InspectionsController < TransamController
  add_breadcrumb "Home", :root_path

  before_action :set_inspection, only: [:show, :edit, :update, :destroy]

  INDEX_KEY_LIST_VAR    = "inspection_key_list_cache_var"
  INSPECTION_SEARCH_PROXY_CACHE_VAR    = "inspection_proxy_cache_var"

  # GET /inspections
  def index
    #---------------------------------------------------------------------------
    # Set up any view vars needed to set the search context
    #---------------------------------------------------------------------------
    if params[:inspection_proxy].present?
      @search_proxy = InspectionProxy.new(inspection_proxy_form_params)
      # Make sure we flag this as not being a new search so the results table will
      # not be hidden
      @search_proxy.new_search = '0'

      cache_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR, @search_proxy)

      # Run the search query
      run_searcher
    else
      setup_inspection_search_vars
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

  #-----------------------------------------------------------------------------
  # Perform a new search for inspections
  #-----------------------------------------------------------------------------
  # POST /inspections/new_search
  def new_search
    @search_proxy = InspectionProxy.new(inspection_proxy_form_params)
    # Make sure we flag this as not being a new search so the results table will
    # not be hidden
    @search_proxy.new_search = '0'

    # Run the search query
    run_searcher

    # cache the search results
    cache_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR, @search_proxy)

    # Cache the result set for paging through the detail view
    cache_list(@search_results, INDEX_KEY_LIST_VAR)

    Rails.logger.debug "Rows returned = #{@search_results.count}"

    respond_to do |format|
      format.js
      format.json { render json: @search_results }
    end
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

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_inspection
      @inspection = Inspection.get_typed_inspection(Inspection.find_by(object_key: params[:id]))
      @asset = @inspection.highway_structure
    end

    # Only allow a trusted parameter "white list" through.
    def inspection_params
      params.require(:inspection).permit(Inspection.allowable_params)
    end

    def inspection_proxy_form_params
      params.require(:inspection_proxy).permit(InspectionProxy.allowable_params)
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
      end

      #---------------------------------------------------------------------------
      # cache the search proxy
      #---------------------------------------------------------------------------
      Rails.logger.debug @search_proxy.inspect
      cache_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR, @search_proxy)

      #---------------------------------------------------------------------------
      # Run the query, this sets @errors and @search_results
      #---------------------------------------------------------------------------
      run_searcher
    end

    def run_searcher
      @searcher = InspectionSearcher.new({user: current_user, search_proxy: @search_proxy})
      @search_results = @searcher.data
      @search_results_count = @search_results.count
      @errors = [] #TODO: not sure what errors can have??
    end
end
