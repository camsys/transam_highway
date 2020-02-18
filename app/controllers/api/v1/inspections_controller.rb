class Api::V1::InspectionsController < Api::ApiController
  # GET /inspections
  def index
    get_data

    # change inspection status from assigned to in_field
    @inspections.where(state: 'assigned').update_all(state: 'in_field')
  end

  # PUT/PATCH /inspections/:id
  def update
    @inspection = Inspection.find_by_object_key(params[:id])
    unless @inspection
      @status = :error
      @message  = "Inspection #{params[:id]} not found"
      render status: 400, json: json_response(:error, message: @message)
      return
    end

    begin
      ActiveRecord::Base.transaction do

        if params[:inspection]
          inspection_hash = params[:inspection].permit(@inspection.allowable_params).to_h
          inspection_hash[:status] = 'in_progress' if @inspection.status == 'in_field' # special case
          @inspection.update!(inspection_hash) if @inspection
        end

        if params[:bridge_condition]
          @bridge_condition = Inspection.get_typed_inspection(@inspection)
          bc_hash = params[:bridge_condition].permit(@bridge_condition.allowable_params).to_h
          @bridge_condition.update!(bc_hash) if @bridge_condition
        end

        if params[:culvert_condition]
          @culvert_condition = Inspection.get_typed_inspection(@inspection)
          cc_hash = params[:culvert_condition].permit(@culvert_condition.allowable_params).to_h
          @culvert_condition.update!(cc_hash) if @culvert_condition
        end

        if params[:ancillary_condition]
          @ancillary_condition = Inspection.get_typed_inspection(@inspection)
          ac_hash = params[:ancillary_condition].permit(@ancillary_condition.allowable_params).to_h
          @ancillary_condition.update!(ac_hash) if @ancillary_condition
        end

        if params[:structure]
          @structure = TransamAsset.get_typed_asset(@inspection.highway_structure)
          structure_hash = params[:structure].permit(@structure.allowable_params).to_h
          @structure&.update!(structure_hash)
        end

        if params[:elements] && params[:elements].any?
          params[:elements].each do |el_params|
            change_type = el_params[:change_type]&.upcase

            clean_params = el_params.permit(Element.allowable_params).to_h
            el_guid = el_params[:id]
            if el_params[:parent_id]
              el_parent = Element.find_by_guid(el_params[:parent_id])
            end

            case change_type
            when 'ADD', 'UPDATE'
              el = Element.find_by_guid(el_guid)
              clean_params[:parent] = el_parent if el_parent
              clean_params[:inspection] = @inspection
              if el
                el.update!(clean_params)
              else
                if el_guid.blank?
                  @el_guid_required_to_add = true
                  raise ActiveRecord::Rollback
                end
                clean_params["guid"] = el_guid
                Element.create!(clean_params)
              end
            when 'REMOVE'
              el = Element.find_by_guid(el_guid)
              el.destroy! if el
            end
          end
        end

        if params[:defects] && params[:defects].any?
          params[:defects].each do |df_params|
            change_type = df_params[:change_type]&.upcase

            clean_params = df_params.permit(Defect.allowable_params).to_h
            df_guid = df_params[:id]
            if df_params[:element_id]
              el_parent = Element.find_by_guid(df_params[:element_id])
            end

            case change_type
            when 'ADD', 'UPDATE'
              el = Defect.find_by_guid(df_guid)
              clean_params[:element] = el_parent if el_parent
              clean_params[:inspection] = @inspection
              if el
                el.update!(clean_params)
              else
                if df_guid.blank?
                  @df_guid_required_to_add = true
                  raise ActiveRecord::Rollback
                end
                clean_params["guid"] = df_guid
                Defect.create!(clean_params)
              end
            when 'REMOVE'
              el = Defect.find_by_guid(df_guid)
              el.destroy! if el
            end
          end
        end

        if params[:defect_locations] && params[:defect_locations].any?
          params[:defect_locations].each do |dl_params|
            change_type = dl_params[:change_type]&.upcase

            clean_params = dl_params.permit(DefectLocation.allowable_params).to_h
            dl_guid = dl_params[:id]
            if dl_params[:defect_id]
              dl_parent = Defect.find_by_guid(dl_params[:defect_id])
            end

            case change_type
            when 'ADD', 'UPDATE'
              dl = DefectLocation.find_by_guid(dl_guid)
              clean_params[:defect] = dl_parent if dl_parent
              if dl
                dl.update!(clean_params)
              else
                if dl_guid.blank?
                  @dl_guid_required_to_add = true
                  raise ActiveRecord::Rollback
                end
                clean_params["guid"] = dl_guid
                DefectLocation.create!(clean_params)
              end
            when 'REMOVE'
              dl = DefectLocation.find_by_guid(dl_guid)
              dl.destroy! if dl
            end
          end
        end

        if params[:streambed_profiles] && params[:streambed_profiles].any?
          params[:streambed_profiles].each do |sp_params|
            change_type = sp_params[:change_type]&.upcase

            clean_params = sp_params.permit(sp_params.keys).except(:id, :highway_structure_id, :inspection_id, :change_type).to_h
            sp_guid = sp_params[:id]
            if sp_params[:highway_structure_id]
              sp_parent = HighwayStructure.find_by(guid: sp_params[:highway_structure_id])
            end
            if sp_params[:inspection_id]
              sp_inspection = Inspection.find_by(guid: sp_params[:inspection_id])
            end

            case change_type
            when 'ADD', 'UPDATE'
              sp = StreambedProfile.find_by_guid(sp_guid)
              clean_params[:transam_asset_id] = sp_parent.id if sp_parent
              clean_params[:inspection_id] = sp_inspection.id if sp_inspection
              if sp
                sp.update!(clean_params)
              else
                if sp_guid.blank?
                  @sp_guid_required_to_add = true
                  raise ActiveRecord::Rollback
                end
                clean_params["guid"] = sp_guid
                clean_params[:is_from_api] = true
                StreambedProfile.create!(clean_params)
              end
            when 'REMOVE'
              sp = StreambedProfile.find_by_guid(sp_guid)
              sp.destroy! if sp
            end
          end
        end

        if params[:streambed_profile_points] && params[:streambed_profile_points].any?
          params[:streambed_profile_points].each do |spp_params|
            change_type = spp_params[:change_type]&.upcase

            clean_params = spp_params.permit(spp_params.keys).except(:id, :profile_id, :change_type).to_h
            spp_guid = spp_params[:id]
            if spp_params[:profile_id]
              spp_parent = StreambedProfile.find_by_guid(spp_params[:profile_id])
            end

            case change_type
            when 'ADD', 'UPDATE'
              spp = StreambedProfilePoint.find_by_guid(spp_guid)
              clean_params[:streambed_profile] = spp_parent if spp_parent
              if spp
                spp.update!(clean_params)
              else
                if spp_guid.blank?
                  @spp_guid_required_to_add = true
                  raise ActiveRecord::Rollback
                end
                clean_params["guid"] = spp_guid
                StreambedProfilePoint.create!(clean_params)
              end
            when 'REMOVE'
              spp = StreambedProfilePoint.find_by_guid(spp_guid)
              spp.destroy! if spp
            end
          end
        end

        if params[:roadbeds] && params[:roadbeds].any?
          params[:roadbeds].each do |rb_params|
            change_type = rb_params[:change_type]&.upcase

            clean_params = rb_params.permit(rb_params.keys).except(:id, :roadway_id, :change_type).to_h
            rb_guid = rb_params[:id]
            if rb_params[:roadway_id]
              rb_parent = Roadway.find_by_guid(rb_params[:roadway_id])
            end

            case change_type
            when 'ADD', 'UPDATE'
              rb = Roadbed.find_by_guid(rb_guid)
              clean_params[:roadway] = rb_parent if rb_parent
              if rb
                rb.update!(clean_params)
              else
                if rb_guid.blank?
                  @rb_guid_required_to_add = true
                  raise ActiveRecord::Rollback
                end

                clean_params["guid"] = rb_guid
                Roadbed.create!(clean_params)
              end
            when 'REMOVE'
              rb = Roadbed.find_by_guid(rb_guid)
              rb.destroy! if rb
            end
          end
        end

        if params[:roadbed_lines] && params[:roadbed_lines].any?
          params[:roadbed_lines].each do |rbl_params|
            change_type = rbl_params[:change_type]&.upcase

            clean_params = rbl_params.permit(rbl_params.keys).except(:id, :roadbed_id, :inspection_id, :number, :change_type, :does_not_exist, :no_restriction).to_h
            rbl_guid = rbl_params[:id]

            case change_type
            when 'ADD', 'UPDATE'
              if rbl_params[:inspection_id]
                rbl_parent = Inspection.find_by_guid(rbl_params[:inspection_id])
              end
              if rbl_params[:roadbed_id]
                rbl_roadbed = Roadbed.find_by_guid(rbl_params[:roadbed_id])
              end
              unless rbl_roadbed
                @roadbed_required_to_add_update = true
                raise ActiveRecord::Rollback
              end
              if rbl_params[:number]
                case rbl_params[:number]
                when 0
                  rbl_number = "L"
                when rbl_roadbed&.number_of_lines + 1
                  rbl_number = "R"
                else
                  rbl_number = rbl_params[:number]&.to_s
                end
              end

              rbl = RoadbedLine.find_by_guid(rbl_guid)
              clean_params[:inspection] = rbl_parent if rbl_parent
              clean_params[:roadbed] = rbl_roadbed if rbl_roadbed
              clean_params[:number] = rbl_number if rbl_number
              if rbl_params[:no_restriction]
                clean_params[:entry] = clean_params[:exit] = clean_params[:minimum_clearance] = nil
              elsif rbl_params[:does_not_exist]
                if rbl_roadbed.try(:use_minimum_clearance?)
                  clean_params[:minimum_clearance] = 0.0
                else
                  clean_params[:entry] = clean_params[:exit] = 0.0
                end
              end
              if rbl
                rbl.update!(clean_params)
              else
                if rbl_guid.blank?
                  @rbl_guid_required_to_add = true
                  raise ActiveRecord::Rollback
                end

                clean_params["guid"] = rbl_guid
                RoadbedLine.create!(clean_params)
              end
            when 'REMOVE'
              rbl = RoadbedLine.find_by_guid(rbl_guid)
              rbl.destroy! if rbl
            end
          end
        end

        if (@inspection.highway_structure&.respond_to? :maintenance_history) && params[:maintenance_items] && params[:maintenance_items].any?
          params[:maintenance_items].each do |mi_params|
            change_type = mi_params[:change_type]&.upcase

            clean_params = mi_params.permit(:notes, :order_date).to_h
            event_params = {}
            mi_guid = mi_params[:id]
            if mi_params[:highway_structure_id]
              mi_parent = HighwayStructure.find_by(guid: mi_params[:highway_structure_id])
            end
            if mi_params[:priority]
              mi_priority = MaintenancePriorityType.find_by(name: mi_params[:priority])
            end
            if mi_params[:status]
              mi_state = mi_params[:status] if MaintenanceServiceOrder.state_machine.states[mi_params[:status]]
            end
            if mi_params[:recommendation]
              mi_recommendation = MaintenanceActivityType.find_by(name: mi_params[:recommendation])
            end
            if mi_params[:timeline]
              mi_due_date = mi_params[:timeline]
            end
            if mi_params[:date_completed]
              mi_date_completed = mi_params[:date_completed]
            end

            case change_type
            when 'ADD', 'UPDATE'
              mi = MaintenanceServiceOrder.find_by_guid(mi_guid)
              clean_params[:transam_asset] = mi_parent if mi_parent
              clean_params[:priority_type] = mi_priority if mi_priority
              clean_params[:state] = mi_state if mi_state

              # TODO: Event parameters are only valid for the first maintenance event under the service order for now
              event_params[:maintenance_activity_type] = mi_recommendation if mi_recommendation
              event_params[:due_date] = mi_due_date if mi_due_date
              event_params[:event_date] = mi_date_completed if mi_date_completed

              if mi
                mi.update!(clean_params)
                mi.maintenance_events.first.update!(event_params)
              else
                if mi_guid.blank?
                  @mi_guid_required_to_add = true
                  raise ActiveRecord::Rollback
                end
                clean_params["guid"] = mi_guid
                clean_params[:organization] = @user.organization
                order = MaintenanceServiceOrder.create!(clean_params)
                event_params[:maintenance_service_order] = order if order
                event_params[:transam_asset] = order&.transam_asset
                MaintenanceEvent.create!(event_params)
              end
            when 'REMOVE'
              mi = MaintenanceServiceOrder.find_by_guid(mi_guid)
              MaintenanceEvent.where(maintenance_service_order: mi).destroy_all if mi
              mi.destroy! if mi
            end
          end
        end

        @is_valid = true
      end
    rescue ActiveRecord::RecordInvalid => invalid
      # generic errors
      @status = :error
      @message  = "Unable to update inspection #{params[:id]} due to the following error: #{invalid.record.errors.messages}"
      render status: 400, json: json_response(:error, message: @message)
    end

    # element guid is required to add a new element
    if @el_guid_required_to_add
      @status = :error
      @message  = "Unable to update inspection #{params[:id]} due to empty id in new element data"
      render status: 400, json: json_response(:error, message: @message)
    end

    # defect guid is required to add a new defect
    if @df_guid_required_to_add
      @status = :error
      @message  = "Unable to update inspection #{params[:id]} due to empty id in new defect data"
      render status: 400, json: json_response(:error, message: @message)
    end

    # defect location guid is required to add a new defect location
    if @dl_guid_required_to_add
      @status = :error
      @message  = "Unable to update inspection #{params[:id]} due to empty id in new defect location data"
      render status: 400, json: json_response(:error, message: @message)
    end

    # streambed profile guid is required to add a new streambed profile
    if @sp_guid_required_to_add
      @status = :error
      @message = "Unable to update inspection #{params[:id]} due to empty id in new streambed profile data"
      render status: 400, json: json_response(:error, message: @message)
    end

    # streambed profile point guid is required to add a new streambed profile point
    if @spp_guid_required_to_add
      @status = :error
      @message = "Unable to update inspection #{params[:id]} due to empty id in new streambed profile point data"
      render status: 400, json: json_response(:error, message: @message)
    end

    # roadbed guid is required to add a new roadbed
    if @rb_guid_required_to_add
      @status = :error
      @message = "Unable to update inspection #{params[:id]} due to empty id in new roadbed data"
      render status: 400, json: json_response(:error, message: @message)
    end

    # roadbed is required to add/update a new roadbed line
    if @roadbed_required_to_add_update
      @status = :error
      @message = "Unable to update inspection #{params[:id]} due to missing roadbed"
      render status: 400, json: json_response(:error, message: @message)
    end

    # roadbed line guid is required to add a new roadbed line
    if @rbl_guid_required_to_add
      @status = :error
      @message = "Unable to update inspection #{params[:id]} due to empty id in new roadbed line data"
      render status: 400, json: json_response(:error, message: @message)
    end

    # maintenance item guid is required to add a new maintenance item
    if @mi_guid_required_to_add
      @status = :error
      @message = "Unable to update inspection #{params[:id]} due to empty id in new maintenance item data"
      render status: 400, json: json_response(:error, message: @message)
    end
  end

  private

  def get_data
    # sequence matters
    query_highway_structures
    query_bridges
    query_culverts
    query_ancillary_structures
    query_miscellaneous_structures
    query_inspections
    query_bridge_conditions
    query_culvert_conditions
    query_ancillary_conditions
    query_elements
    query_defects
    query_defect_locations
    query_roadways
    query_images
    query_documents
    query_streambed_profiles
    query_streambed_profile_points
    query_roadbeds
    query_roadbed_lines
    if @highway_structures&.first.respond_to? :maintenance_history
      query_maintenance_items
    end
  end

  def query_highway_structures
    inspection_status = [:assigned, :in_field, :in_progress]
    org_ids = @user&.organization_ids

    @highway_structures = HighwayStructure.joins(:inspections).where(inspections: {status: inspection_status, assigned_organization_id: org_ids}).uniq
    unless params[:limit].blank?
      @highway_structures = @highway_structures.limit(params[:limit])
    end

    @highway_structure_ids = @highway_structures.pluck(:id)
    @transam_asset_ids = @highway_structures.pluck("transam_assetible_id")
  end

  def query_bridges
    @bridges = Bridge.bridge_only.where("highway_structures.id": @highway_structure_ids)
    @bridge_asset_ids = @bridges.pluck("transam_assetible_id")
  end

  def query_culverts
    @culverts = Culvert.where("highway_structures.id": @highway_structure_ids)
    @culvert_asset_ids = @culverts.pluck("transam_assetible_id")
  end

  def query_ancillary_structures
    @highway_signs = HighwaySign.where("highway_structures.id": @highway_structure_ids)
    @highway_signals = HighwaySignal.where("highway_structures.id": @highway_structure_ids)
    @high_mast_lights = HighMastLight.where("highway_structures.id": @highway_structure_ids)
    @ancillary_asset_ids = @highway_signs.or(@highway_signals).or(@high_mast_lights).pluck("transam_assetible_id")
  end

  def query_miscellaneous_structures
    @miscellaneous_structures = MiscStructure.where("highway_structures.id": @highway_structure_ids)
    @misc_asset_ids = @miscellaneous_structures.pluck("transam_assetible_id")
  end

  def query_inspections
    @inspection_ids = []
    # return open inspection and last two finished ones
    @highway_structures.each do |s|
      @inspection_ids += s.inspections.ordered.limit(3).pluck("inspections.id")
    end

    @inspections = Inspection.where(id: @inspection_ids)
  end

  def query_bridge_conditions
    @bridge_conditions = BridgeCondition.where("inspections.id": @inspection_ids, "transam_asset_id": @bridge_asset_ids + @misc_asset_ids)
  end

  def query_culvert_conditions
    @culvert_conditions = CulvertCondition.where("inspections.id": @inspection_ids, "transam_asset_id": @culvert_asset_ids)
  end

  def query_ancillary_conditions
    @ancillary_conditions = AncillaryCondition.where("inspections.id": @inspection_ids, "transam_asset_id": @ancillary_asset_ids)
  end

  def query_elements
    @elements = Element.where(inspection_id: @inspection_ids)
  end

  def query_defects
    @defects = Defect.where(inspection_id: @inspection_ids)
  end

  def query_defect_locations
    @defect_locations = DefectLocation.where(defect: @defects)
  end

  def query_roadways
    @roadways = Roadway.where(transam_asset_id: @transam_asset_ids)
  end

  def query_images
    @images = Image.where(imagable_type: 'TransamAsset', imagable_id: @transam_asset_ids)
              .or(Image.where(imagable_type: 'Inspection', imagable_id: @inspection_ids))
              .or(Image.where(imagable_type: 'Element', imagable_id: @elements))
              .or(Image.where(imagable_type: 'Defect', imagable_id: @defects))
              .or(Image.where(imagable_type: 'DefectLocation', imagable_id: @defect_locations))
  end

  def query_documents
    @documents = Document.where(documentable_type: 'TransamAsset', documentable_id: @transam_asset_ids)
  end

  def query_streambed_profiles
    @profiles = StreambedProfile.where(transam_asset_id: @transam_asset_ids)
  end

  def query_streambed_profile_points
    @profile_points = StreambedProfilePoint.where(streambed_profile: @profiles)
  end

  def query_roadbeds
    @roadbeds = Roadbed.where(roadway: @roadways)
  end

  def query_roadbed_lines
    @roadbed_lines = RoadbedLine.where(inspection: @inspections)
  end

  def query_maintenance_items
    @maintenance_items = MaintenanceServiceOrder.where(transam_asset_id: @transam_asset_ids)
  end

end
