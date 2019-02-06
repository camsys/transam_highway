class Inspection < ApplicationRecord

  include TransamObjectKey

  belongs_to :highway_structure, foreign_key: :transam_asset_id

  belongs_to :inspection_type

  has_and_belongs_to_many :inspectors, class_name: 'User', join_table: 'inspections_users'

  has_many :elements
end
