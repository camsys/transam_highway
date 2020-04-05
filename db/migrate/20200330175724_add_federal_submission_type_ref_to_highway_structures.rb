class AddFederalSubmissionTypeRefToHighwayStructures < ActiveRecord::Migration[5.2]
  def change
    add_reference :highway_structures, :federal_submission_type, foreign_key: true
  end
end
