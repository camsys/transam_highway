class AddWorkflowFieldsInspection < ActiveRecord::Migration[5.2]
  def change
    add_reference :inspections, :assigned_organization, after: :transam_asset_id

    add_column :inspections, :state, :string, after: :assigned_organization_id
  end
end
