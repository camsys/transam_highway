class JoinAssetTypesAssemblyTypes < ActiveRecord::DataMigration
  def up
    {
      'Bridge' => ['Deck', 'Superstructure', 'Substructure', 'Joints', 'Rails', 'Other'],
      'Culvert' => ['Deck', 'Superstructure', 'Substructure', 'Joints', 'Rails', 'Other'],
      'Highway Sign' => ['Ancillary', 'Other', 'Rails'],
      'Highway Signal' => ['Ancillary', 'Other', 'Rails'],
      'High Mast Light' => ['Ancillary', 'Other', 'Rails'],
      'Miscellaneous Structure' => ['Deck', 'Superstructure', 'Substructure', 'Joints', 'Rails', 'Other', 'Ancillary']
    }.each do |asset_type, assembly_types|
      AssetType.find_by(name: asset_type).assembly_type_ids =
        AssemblyType.where(name: assembly_types).pluck(:id)
    end
  end
end
