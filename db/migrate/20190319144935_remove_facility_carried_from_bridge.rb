class RemoveFacilityCarriedFromBridge < ActiveRecord::Migration[5.2]
  def change
    remove_column :bridges, :facility_carried, :string
  end
end
