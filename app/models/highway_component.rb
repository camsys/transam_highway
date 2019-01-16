class HighwayComponent < TransamAssetRecord

  acts_as :transam_asset, as: :transam_assetible

  actable as: :highway_componentible

end
