class AddInitialFederalSubmissionTypes < ActiveRecord::DataMigration
  def up
    types = [
      {
        name: "No Federal Submission",
        description: "No Federal Submission",
        active: true
      },
      {
          name: "NBI/NBE Submission",
          description: "NBI/NBE Submission",
          active: true
      },
      {
          name: "NBI/NBE (Others Submit)",
          description: "NBI/NBE (Others Submit)",
          active: true
      }
    ]

    types.each do |t|
      FederalSubmissionType.find_or_create_by(t)
    end
  end
end