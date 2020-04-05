class CreateHighwayConsultantsOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :highway_consultants_organizations do |t|
      t.integer :highway_consultant_id, index: {name: :highway_consultants_organizations_highway_consultant_idx}
      t.integer :organization_id, index: {name: :highway_consultants_organizations_organization_idx}
    end
  end
end
