class HighwayMapsController < MapsController
  before_action :get_highway_class_view, only: [:table, :map]
  before_action :get_highway_assets, only: [:table, :map]

  def table
    add_breadcrumb "Table"

    process_sort

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

    @asset_class_name = "HighwayStructure"
    
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

    @searcher.asset_seed_class_name = @asset_class_name
    @searcher.set_seed_class

    if @searcher.respond_to? :organization_id
      @searcher.organization_id = @organization_list
    end
    @searcher.user = current_user
    @assets = @searcher.data
  end

  def process_sort
    # check that an order param was provided otherwise use asset_tag as the default
    params[:sort] ||= 'transam_assets.asset_tag'

    # fix sorting on organizations to be alphabetical not by index
    params[:sort] = 'organizations.short_name' if params[:sort] == 'organization_id'

    if @asset_class_name == 'TransamAsset'
      @assets = @assets.includes({asset_subtype: :asset_type},:organization, :manufacturer)
    else
      join_relations = @klass.actable_hierarchy
      if join_relations == :transam_asset
          join_relations = {transam_asset: [{asset_subtype: :asset_type},:organization, :manufacturer]}
      else
        join_relations[join_relations.key(:transam_asset)] = {transam_asset: [{asset_subtype: :asset_type},:organization, :manufacturer]}
      end
      
      @assets = @assets.includes(join_relations)
    end
  end
end