class HighwayMapsController < MapsController
  before_action :get_highway_class_view, only: [:table, :map]
  before_action :get_highway_assets, only: [:table, :map]

  def table
    add_breadcrumb "Table"
    
    @assets = @assets.very_specific

    respond_to do |format|
      format.html
      format.js
      format.json {
        render :json => {
          :total => @assets.count,
          :rows =>  index_rows_as_json
          }
        }
      format.xls do
        filename = (terminal_crumb || "unknown").gsub(" ", "_").underscore
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}.xls"
      end
      format.xlsx do
        filename = (terminal_crumb || "unknown").gsub(" ", "_").underscore
        response.headers['Content-Disposition'] = "attachment; filename=#{filename}.xlsx"
      end
    end
  end

  def map
    add_breadcrumb "Map"

    @show_default = true if params[:show_default] == 'true'
  end

  private

  def index_rows_as_json
    multi_sort = params[:multiSort]

    unless (multi_sort.nil?)
      sorting_string = ""

      multi_sort.each { |x|
        sorting_string = sorting_string + "#{x[0]}: :#{x[1]}"
      }

    else
      sorting_string = "#{params[:sort]} #{params[:order]}"
    end


    @assets.limit(params[:limit]).offset(params[:offset]).as_json(user: current_user, include_early_disposition: @early_disposition)

  end

  def get_highway_class_view
    if params[:searcher] && !params[:searcher][:asset_type_id].blank?
      asset_types = AssetType.where(id: params[:searcher][:asset_type_id])
    end

    if asset_types && asset_types.size == 1
      @asset_type = asset_types.first
      @asset_class_name = @asset_type.class_name
    else
      @asset_class_name = "HighwayStructure"
    end
    
    @klass = Object.const_get @asset_class_name
    @view = "#{@asset_class_name.underscore}_table_index"

    @search_params = {}
    if params && !params[:searcher].blank?
      params[:searcher].each do |k, v|
        @search_params[k] = v
      end
    end
  end

  def get_highway_assets
    if params[:searcher].blank?
      @searcher = AssetMapSearcher.new
    else
      @searcher = AssetMapSearcher.new(params[:searcher])
    end

    if @searcher.respond_to? :organization_id
      @searcher.organization_id = @organization_list
    end
    @searcher.user = current_user
    @assets = @searcher.data
  end
end