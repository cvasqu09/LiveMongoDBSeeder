require 'roo'
require 'json'
require 'byebug'
require 'mongo'
require 'rest-client'
require 'json'

class MongoSeeder

	def initialize(path_to_events_json, path_to_users_json)
		events_json_file = File.read(path_to_events_json)
		users_json_file = File.read(path_to_users_json)
		@events = JSON.parse(events_json_file)
		@users = JSON.parse(users_json_file)
	end

	def seed_events
		clear_db('events')
		@events.each do |event|
			post('http://localhost:3000/api/events', event.to_json)
		end
	end

	def seed_users
		clear_db('users')
		@users.each do |user|
			post('http://localhost:3000/api/users', user.to_json)
		end
	end

	private 

	def post(endpoint, request)
		puts "posting: #{request}"
		begin
			response = RestClient.post endpoint, request, {content_type: :json, accept: :json}
		rescue => e
			raise "Error occurred: #{e.response}"
		end
	end

	def clear_db(db_name)
		client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'LiveDB')
		client[db_name.to_sym].delete_many({})
		client.close
	end
end


