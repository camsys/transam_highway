class AddFieldReferenceForFederalSubmissionType < ActiveRecord::DataMigration
  def up
    FieldReference.find_or_create_by(field_name: 'federal_submission_type_id', name: 'Federal Submission', number: '147', table:'highway_structures')
  end
end