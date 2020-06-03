class InspectionsController < TransamController
  add_breadcrumb "Home", :root_path

  before_action :set_paper_trail_whodunnit, only: [:create, :update]

  before_action :set_inspection, only: [:show, :edit, :update, :destroy, :allowed_to_finalize, :edit_inspectors]
  before_action :reformat_date_fields, only: [:create, :update]

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

  def edit_inspectors

  end

  def change_inspectors
    params[:inspector_assignment_proxy][:global_ids] = params[:inspector_assignment_proxy][:global_ids].split(',')

    inspector_assignment_proxy = InspectorAssignmentProxy.new(inspector_assignment_proxy_form_params)

    # make sure there's only one assigned organization
    assigned_org_id = inspector_assignment_proxy.inspections.map{|x| x.assigned_organization_id}.uniq
    if assigned_org_id.length == 1
      assigned_org_id = assigned_org_id.first
    else
      notify_user(:alert, "More than one team selected.")
      return
    end

    inspector_assignment_proxy.inspections.each do |insp|
      User.joins(:organizations).where(id:inspector_assignment_proxy.inspector_ids, organizations: {id: assigned_org_id}).distinct.each do |inspector|
        if inspector_assignment_proxy.is_removal.to_i > 0
          insp.inspectors.delete(inspector)
        elsif !(insp.inspectors.include?(inspector))
          insp.inspectors << inspector
        end
      end
    end

    respond_to do |format|
      format.html { redirect_back(fallback_location: root_path) }
    end

  end

  def audit_export

    @start_date = Chronic.parse(params[:start_date]).beginning_of_day unless params[:start_date].blank?
    @end_date = Chronic.parse(params[:end_date]).end_of_day unless params[:end_date].blank?

    respond_to do |format|
      format.html
      format.csv {
        @export_results = InspectionAuditService.new.table_of_changes(nil,@start_date, @end_date)
      }
    end
  end


  def nbi_export
    @search_proxy = get_cached_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR)
    respond_to do |format|
      format.html {
        if @search_proxy.blank?
          notify_user(:alert, "Please perform a search first.")
          redirect_back(fallback_location: root_path)
        else
          inspections = InspectionSearcher.new({user: current_user, search_proxy: @search_proxy}).data
          txt = NbiSubmissionGenerator.nbi_for_list(inspections)
          send_data(txt, type: :txt)
          cache_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR, @search_proxy)
        end
      }
    end
  end

  def nbe_export
    @search_proxy = get_cached_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR)
    respond_to do |format|
      format.xml {
        if @search_proxy.blank?
          notify_user(:alert, "Please perform a search first.")
          redirect_back(fallback_location: root_path)
        else
          inspections = InspectionSearcher.new({user: current_user, search_proxy: @search_proxy}).data
          xml = NbeSubmissionGenerator.xml_for_elements(inspections)
          send_data(xml.to_xml, type: :xml)
          cache_objects(INSPECTION_SEARCH_PROXY_CACHE_VAR, @search_proxy)
        end
      }
    end
  end

  def qa_qc_export
    respond_to do |format|
      format.xml {
        if params[:global_ids].blank?
          notify_user(:alert, "Please select some rows first.")
          redirect_back(fallback_location: root_path)
        else
          xml = QaQcSubmissionGenerator.xml_for_structures(params[:global_ids].split(','))
          send_data(xml.to_xml, type: :xml)
        end
      }
    end
  end

  def inspection_type_settings
    @asset = TransamAsset.get_typed_asset(TransamAsset.find_by(object_key: params[:asset_object_key]))

    if @asset
      @not_special_settings = []

      @asset.class.inspection_types.active.can_be_recurring.not_special.each do |type|
        @not_special_settings << @asset.inspection_type_settings.find_or_initialize_by(inspection_type: type)
      end

      @special_settings = @asset.inspection_type_settings.where(inspection_type: @asset.class.inspection_types.active.special)
      if @special_settings.empty?
        @special_settings = [@asset.inspection_type_settings.build(inspection_type: InspectionType.find_by(name: 'Special'))]
      end
    end
  end

  # GET /inspections/1
  def show
    add_breadcrumb "#{@asset.asset_type.name}".pluralize,
                   inventory_index_path(:asset_type => @asset.asset_type, :asset_subtype => 0)
    add_breadcrumb @asset, inventory_path(@asset)
    add_breadcrumb "#{view_context.format_as_date(@inspection.event_datetime)} Inspection"

    @asset_class_name = @asset.asset_type.class_name

    @show_debug = params[:debug] && ['development', 'staging'].include?(Rails.env)
    @sshml = ['HighwaySign', 'HighwaySignal', 'HighMastLight'].include? @asset.asset_type.class_name

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @inspection }

      format.pdf do
        # pdf = WickedPdf.new.pdf_from_string(inspection_pdf_template(@inspection) )
        send_data(inspection_pdf_template(@inspection), type: 'application/pdf', disposition: 'inline', filename: 'InspectionReport.pdf')

        # render :pdf => inspection_pdf_template(@inspection), :disposition => 'inline'
      end
    end

  end

  # GET /inspections/new
  def new
    @asset = TransamAsset.get_typed_asset(TransamAsset.find_by(object_key: params[:asset_object_key])) if params[:asset_object_key]
    @inspection = Inspection.new(highway_structure: @asset.try(:highway_structure))
  end

  # GET /inspections/1/edit
  def edit
  end

  def allowed_to_finalize

  end

  # POST /inspections
  def create
    @asset = TransamAsset.get_typed_asset(HighwayStructure.find_by(id: params[:inspection][:transam_asset_id]))
    if @asset
      generator = InspectionGenerator.new(InspectionTypeSetting.new(inspection_params.slice(*(InspectionTypeSetting.allowable_params-[:description]))), true)
      @inspection = generator.create
      if @inspection.update(inspection_params)
        redirect_to inventory_path(@asset.object_key), notice: 'Inspection was successfully created.'
      else
        render :new
      end
    end
  end

  # PATCH/PUT /inspections/1
  def update
    respond_to do |format|
      if @inspection.update!(typed_inspection_params(@inspection))

        # do any automatic workflow transitions that are allowed
        (Inspection.automatic_transam_workflow_transitions & @inspection.allowable_events).each do |transition|
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
    highway_structure = @inspection.highway_structure
    @inspection.destroy
    redirect_to inventory_url(highway_structure.object_key), notice: 'Inspection was successfully destroyed.'
  end

  #-----------------------------------------------------------------------------
  # Print an inspection.
  #-----------------------------------------------------------------------------
  #  /inspections/1/print
  def print

    set_inspection

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @inspection }

      format.pdf do
        # pdf = WickedPdf.new.pdf_from_string(inspection_pdf_template(@inspection) )
        send_data(inspection_pdf_template(@inspection), type: 'application/pdf', disposition: 'inline', filename: 'InspectionReport.pdf')

        # render :pdf => inspection_pdf_template(@inspection), :disposition => 'inline'
      end
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

      if @inspection
        if @inspection.state == 'final'
          @asset = TransamAsset.get_typed_version(@inspection.highway_structure_version)
        else
          @asset = TransamAsset.get_typed_asset(@inspection.highway_structure)
        end
      else
        redirect_to '/404'
      end
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

    def inspector_assignment_proxy_form_params
      params.require(:inspector_assignment_proxy).permit(InspectorAssignmentProxy.allowable_params)
    end

    def reformat_date_fields
      params[:inspection][:calculated_inspection_due_date] = reformat_date(params[:inspection][:calculated_inspection_due_date]) unless params[:inspection][:calculated_inspection_due_date].blank?
    end

    def reformat_date(date_str)
      # See if it's already in iso8601 format first
      return date_str if date_str.match(/\A\d{4}-\d{2}-\d{2}\z/)

      Date.strptime(date_str, '%m/%d/%Y').strftime('%Y-%m-%d')
    end

    def inspection_pdf_template inspection
      render_to_string(
          pdf: "#{inspection}",
          :margin => {
              :top => 21,
              :bottom => 7
          },
          :show_as_html => params[:debug].present?,
          :layout => 'pdf.html',
          :template => 'inspections/print.pdf.haml',
          :orientation => 'portrait',
          :footer => {
              :center => view_context.format_for_pdf_printing(Time.now),
              :left => "Printed by #{current_user}",
              :right => 'Page [page] of [topage]'
          }
      )
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
        @search_proxy.assigned_organization_id = current_user.organization_id
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
      @searcher = InspectionSearcher.new({user: current_user, search_proxy: @search_proxy})
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
