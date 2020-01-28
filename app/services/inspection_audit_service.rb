class InspectionAuditService

  def table_of_changes(typed_asset)# initialize empty array to store changes that matter to use
    changes_arr = []

    # get changes that are applicable
    where_clause = (['object_changes LIKE ?']*Rails.application.config.inspection_audit_changes.count).join (' OR ')
    values = Rails.application.config.inspection_audit_changes.map{|x| "%#{x.split('.')[1]}%"}

    versions = PaperTrail::Version.where(where_clause, *values).order(created_at: :desc)

    if typed_asset
      items = [typed_asset.becomes(BridgeLike), typed_asset.highway_structure, typed_asset.bridge_like_conditions, typed_asset.inspection_type_settings].flatten
      versions = versions.where(item: items)

      versions.each do |version|
        (version.changeset.keys & Rails.application.config.inspection_audit_changes.map{|x| x.split('.')[1]}).each do |col_change|
          changes_arr << [typed_asset.structure_key, col_change] + version.changeset[col_change] + [version.whodunnit, version.created_at]
        end
      end
    else
      versions.each do |version|
        (version.changeset.keys & Rails.application.config.inspection_audit_changes.map{|x| x.split('.')[1]}).each do |col_change|
          changes_arr << [version.item.try(:structure_key) || version.item.highway_structure.structure_key , col_change] + version.changeset[col_change] + [version.whodunnit, version.created_at]
        end
      end
    end

    return changes_arr
  end
end