# desc "Explaining what the task does"
# task :transam_highway do
#   # Task goes here
# end

namespace :transam_highway do
  desc "Prepare the dummy app for rspec and capybara"
  task :prepare_rspec => ["app:test:set_test_env", :environment] do
    %w(db:drop db:create db:schema:load db:migrate db:seed).each do |cmd|
      puts "Running #{cmd} in Highway"
      Rake::Task[cmd].invoke
    end
  end

  desc "check and add streambed profiles to all non-final inspections"
  task :create_streambed_profiles, [:sql_frag] => [:environment] do |t, args|
    inspections = Inspection.joins('LEFT JOIN streambed_profiles ON inspections.id = streambed_profiles.inspection_id').where(streambed_profiles: {inspection_id: nil}).where.not(state: 'final')

    inspections = inspections.where(args[:sql_frag]) unless args[:sql_frag].blank?

    inspections.each do |insp|
      insp.create_streambed_profile
    end
  end
end

namespace :test do
  desc "Custom dependency to set test environment"
  task :set_test_env do # Note that we don't load the :environment task dependency
    Rails.env = "test"
  end
end
