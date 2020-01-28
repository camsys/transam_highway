class InspectionAuditService

  def table_of_changes(typed_asset)# initialize empty array to store changes that matter to use
    changes_arr = []

    assocs = Hash.new
    Rails.application.config.inspection_audit_changes.map{|x| x.split('.')[1]}.select{|x| x.end_with? '_id'}.each do |assoc|

      if assoc.end_with? 'condition_rating_type_id'
        klass = BridgeAppraisalRatingType
      elsif assoc.end_with? 'rating_method_type_id'
        klass = LoadRatingMethodType
      elsif assoc == 'owner_id'
        klass = Organization
      else
        klass = assoc[0..-4].classify.constantize
      end
      assocs[assoc] = klass.pluck(:id, :name).each_with_object({}) { |(f,l),h|  h.update(f=>l) {|_,ov,nv| ov+nv }}
    end

    # get changes that are applicable
    where_clause = (['object_changes LIKE ?']*Rails.application.config.inspection_audit_changes.count).join (' OR ')
    values = Rails.application.config.inspection_audit_changes.map{|x| "%#{x.split('.')[1]}%"}

    versions = PaperTrail::Version.where(where_clause, *values).order(created_at: :desc)

    if typed_asset
      items = [typed_asset.becomes(BridgeLike), typed_asset.highway_structure, typed_asset.bridge_like_conditions, typed_asset.inspection_type_settings].flatten
      versions = versions.where(item: items)

      versions.each do |version|
        (version.changeset.keys & Rails.application.config.inspection_audit_changes.map{|x| x.split('.')[1]}).each do |col_change|
          changes_arr << [typed_asset.asset_tag, col_change] + version.changeset[col_change].map{|x| assocs[col_change][x]} + [version.whodunnit, version.created_at]
        end
      end
    else
      ['BridgeLike', 'HighwayStructure', 'BridgeLikeCondition', 'InspectionTypeSetting'].each do |item_type|
        asset_tag_objs = item_type.constantize.where(id: versions.where(item_type: item_type).select(:item_id))
        if 'HighwayStructure' == item_type
          asset_tag_objs = asset_tag_objs.includes(:transam_asset)
        elsif 'BridgeLikeCondition' == item_type
          asset_tag_objs = asset_tag_objs.includes(inspection: {highway_structure: :transam_asset})
        else
          asset_tag_objs = asset_tag_objs.includes(highway_structure: :transam_asset)
        end

        asset_tags = asset_tag_objs.pluck("#{item_type.tableize}.id", 'asset_tag').each_with_object({}) { |(f,l),h|  h.update(f=>l) {|_,ov,nv| ov+nv }}


        versions.where(item_type: item_type).each do |version|
          changeset = YAML.load(version.object_changes)

          (changeset.keys & Rails.application.config.inspection_audit_changes.map{|x| x.split('.')[1]}).each do |col_change|
            changes_arr << [asset_tags[version.item_id], col_change] + changeset[col_change].map{|x| assocs[col_change][x]} +[version.whodunnit, version.created_at]
          end
        end
      end

    end
    return changes_arr
  end
end