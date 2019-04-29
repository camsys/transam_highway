class Api::V1::InspectionsController < Api::ApiController
  # GET /inspections
  def index
    get_data
  end

  # PUT/PATCH /inspections/:id
  def update
    @inspection = Inspection.find_by_object_key(params[:id])
    begin 
      ActiveRecord::Base.transaction do 

        if params[:inspection]
          inspection_hash = params[:inspection].permit(params[:inspection].keys).except(:id, :high_structure_id).to_h
          inspection_hash[:state] = 'in_progress' if inspection_hash[:state] == 'in_field' # special case
          @inspection.update!(inspection_hash) if @inspection
        end

        if params[:bridge_condition]
          @bridge_condition = Inspection.get_typed_inspection(@inspection)
          bc_hash = params[:bridge_condition].permit(params[:bridge_condition].keys).except(:id).to_h
          @bridge_condition.update!(bc_hash) if @bridge_condition
        end

        if params[:culvert_condition]
          @culvert_condition = Inspection.get_typed_inspection(@inspection)
          cc_hash = params[:culvert_condition].permit(params[:culvert_condition].keys).except(:id).to_h
          @culvert_condition.update!(cc_hash) if @culvert_condition
        end
        
        if params[:elements] && params[:elements].any?
          params[:elements].each do |el_params|
            change_type = el_params[:change_type]&.upcase

            clean_params = el_params.permit(el_params.keys).except(:id, :parent_id, :inspection_id, :change_type).to_h
            el_guid = el_params[:id]
            if el_params[:parent_id]
              el_parent = Element.find_by_guid(el_params[:parent_id])
            end

            next unless ['ADD', 'REMOVE', 'UPDATE'].include?(change_type) 
            if change_type == 'ADD'
              if el_guid.blank?
                @el_guid_required_to_add = true
                raise ActiveRecord::Rollback
              end

              clean_params["guid"] = el_guid
              clean_params.parent = el_parent if el_parent
              Element.create!(clean_params)
            elsif change_type == 'REMOVE'
              el = Element.find_by_guid(el_guid)
              el.destroy! if el
            else
              el = Element.find_by_guid(el_guid)
              clean_params.parent = el_parent if el_parent
              el.update!(clean_params) if el
            end
          end
        end

        if params[:defects] && params[:defects].any?
          params[:defects].each do |df_params|
            change_type = df_params[:change_type]&.upcase

            clean_params = df_params.permit(df_params.keys).except(:id, :element_id, :inspection_id, :change_type).to_h
            df_guid = df_params[:id]
            if df_params[:element_id]
              el_parent = Element.find_by_guid(df_params[:element_id])
            end
            
            next if ['ADD', 'REMOVE', 'UPDATE'].include?(change_type) 
            if change_type == 'ADD'
              if df_guid.blank?
                @df_guid_required_to_add = true
                raise ActiveRecord::Rollback
              end

              clean_params["guid"] = df_guid
              clean_params.element = el_parent if el_parent
              Defect.create!(clean_params)
            elsif change_type == 'REMOVE'
              el = Defect.find_by_guid(df_guid)
              el.destroy! if el
            else
              el = Defect.find_by_guid(df_guid)
              clean_params.element = el_parent if el_parent
              el.update!(clean_params) if el
            end
          end
        end
        @is_valid = true
      end
    rescue ActiveRecord::RecordInvalid => invalid
      raise ActiveRecord::Rollback

      # generic errors
      @status = :fail
      @message  = "Unable to update inspection #{params[:id]} due to the following error: #{invalid.record.errors.messages}" 
      render status: 400, json: json_response(:fail, message: @message)
    end

    # element guid is required to add a new element
    if @el_guid_required_to_add
      @status = :fail
      @message  = "Unable to update inspection #{params[:id]} due to empty id in new element data" 
      render status: 400, json: json_response(:fail, message: @message)
    end

    # defect guid is required to add a new defect
    if @df_guid_required_to_add
      @status = :fail
      @message  = "Unable to update inspection #{params[:id]} due to empty id in new defect data" 
      render status: 400, json: json_response(:fail, message: @message)
    end
  end

  private

  def get_data
    # sequence matters
    query_highway_structures
    query_bridges
    query_culverts
    query_inspections
    query_bridge_conditions
    query_culvert_conditions
    query_elements
    query_defects
    query_roadways
    query_images
    query_documents
  end

  def query_highway_structures
    @highway_structures = HighwayStructure.all
    unless params[:limit].blank?
      @highway_structures = @highway_structures.limit(params[:limit])
    end

    # HACK: until we have filtering by user org, we have a temporary filter here to only
    # include bridges that have inspections, to filter out all the bridge stubs we've
    # added temporarily for sprint 7
    # @highway_structure_ids = @highway_structures.pluck(:id)
    struct_ids = HighwayStructure.all.joins(:inspections).uniq.pluck(:id)
    @highway_structure_ids = params[:limit].blank? ? struct_ids : struct_ids[0, params[:limit].to_i]
    # @transam_asset_ids = @highway_structures.pluck("transam_assetible_id")
    @transam_asset_ids = HighwayStructure.where(id: @highway_structure_ids).pluck("transam_assetible_id")
  end

  def query_bridges
    @bridges = Bridge.where("highway_structures.id": @highway_structure_ids)
    @bridge_asset_ids = @bridges.pluck("transam_assetible_id")
  end

  def query_culverts
    @culverts = Culvert.where("highway_structures.id": @highway_structure_ids)
    @culvert_asset_ids = @bridges.pluck("transam_assetible_id")
  end

  def query_inspections
    @change_inspection_state = true # a flag to be used to change state in API response
    @inspections = Inspection.where(transam_asset_id: @transam_asset_ids)
    unless params[:start_date].blank?
      @inspections = @inspections.where(Inspection.arel_table[:event_datetime].gteq(params[:start_date]))
    end
    unless params[:end_date].blank?
      @inspections = @inspections.where(Inspection.arel_table[:event_datetime].lteq(params[:end_date]))
    end

    @inspection_ids = @inspections.pluck(:id)
  end

  def query_bridge_conditions
    @bridge_conditions = BridgeCondition.where("inspections.id": @inspection_ids, "transam_asset_id": @bridge_asset_ids)
  end

  def query_culvert_conditions
    @culvert_conditions = CulvertCondition.where("inspections.id": @inspection_ids, "transam_asset_id": @culvert_asset_ids)
  end

  def query_elements
    @elements = Element.where(inspection_id: @inspection_ids)
  end

  def query_defects
    @defects = Defect.where(inspection_id: @inspection_ids)
  end

  def query_roadways
    @roadways = Roadway.where(transam_asset_id: @transam_asset_ids)
  end

  def query_images
    @images = Image.where(imagable_type: 'TransamAsset', imagable_id: @transam_asset_ids)
  end

  def query_documents
    @documents = Document.where(documentable_type: 'TransamAsset', documentable_id: @transam_asset_ids)
  end


end
