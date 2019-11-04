class AddAssetTypesSshml < ActiveRecord::DataMigration
  def up
    [
        {name: 'Highway Sign', description: 'Highway Sign', class_name: 'HighwaySign', display_icon_name: 'fa fa-map-signs', map_icon_name: 'blueIcon', active: true},
        {name: 'Highway Signal', description: 'Highway Signal', class_name: 'HighwaySignal', display_icon_name: 'fa fa-map-signs', map_icon_name: 'blueIcon', active: true},
        {name: 'High Mast Light', description: 'High Mast Light', class_name: 'HighMastLight', display_icon_name: 'fa fa-map-signs', map_icon_name: 'blueIcon', active: true},
    ].each do |type|
      AssetType.create!(type)
    end

    [
        {belongs_to: 'asset_type', type: 'HighwaySign', name: 'Overhead Sign', description: 'Overhead sign', active: true},
        {belongs_to: 'asset_type', type: 'HighwaySign', name: 'Overhead Sign, Butterfly', description: 'Overhead Sign, Butterfly', active: true},
        {belongs_to: 'asset_type', type: 'HighwaySign', name: 'Overhead Sign, Cantilever', description: 'Overhead Sign, Cantilever', active: true},
        {belongs_to: 'asset_type', type: 'HighwaySign', name: 'Overhead Sign with Cantilever Sign', description: 'Overhead Sign with Cantilever Sign', active: true},

        {belongs_to: 'asset_type', type: 'HighwaySignal', name: 'Mast Arm Signal', description: 'Mast Arm Signal', active: true},

        {belongs_to: 'asset_type', type: 'HighMastLight', name: 'High Mast Light', description: 'High mast light', active: true},
    ].each do |subtype|
      a = AssetSubtype.new(subtype.except(:belongs_to, :type))
      a.asset_type = AssetType.find_by(class_name: subtype[:type])
      a.save!
    end

  end
end