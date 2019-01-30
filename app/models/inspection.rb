class Inspection < ApplicationRecord

  include TransamObjectKey

  belongs_to :highway_structure, foreign_key: :transam_asset_id

  has_and_belongs_to_many :inspectors, class_name: 'User', join_table: 'inspections_users'

end
