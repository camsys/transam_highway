class CreateFederalSubmissionTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :federal_submission_types do |t|
      t.string :name
      t.string :description
      t.boolean :active
    end
  end
end
