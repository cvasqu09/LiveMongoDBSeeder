require_relative 'seed-db'

task :clean_and_seed, [:path_to_events_json] do |_, args|
	seeder = MongoSeeder.new(args[:path_to_events_json])
	seeder.seed_events
end