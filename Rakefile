require_relative 'seed-db'

task :clean_and_seed, [:path_to_events_json, :path_to_users_json] do |_, args|
	seeder = MongoSeeder.new(args[:path_to_events_json], args[:path_to_users_json])
	seeder.seed_events
	seeder.seed_users
end