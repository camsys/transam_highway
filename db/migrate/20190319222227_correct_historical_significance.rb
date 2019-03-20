class CorrectHistoricalSignificance < ActiveRecord::Migration[5.2]
  def change
    remove_reference :highway_structures, :highway_significance_type
    add_reference :highway_structures, :historical_significance_type
  end
end
