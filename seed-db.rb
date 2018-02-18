require 'roo'
require 'json'
require 'byebug'
require 'mongo'
require 'rest-client'
require 'json'

class MongoSeeder

	def initialize(path_to_events_json)
		file = File.read(path_to_events_json)
		@events = JSON.parse(file) 
	end

	def seed_events
		clear_events_db
		@events.each do |event|
			post_event(event.to_json)
		end
	end

	private 

	def post_event(request)
		puts "posting: #{request}"
		begin
			response = RestClient.post 'http://localhost:3000/api/events', request, {content_type: :json, accept: :json}
		rescue => e
			raise "Error occurred: #{e.response}"
		end
	end

	def clear_events_db
		client = Mongo::Client.new(['127.0.0.1:27017'], :database => 'LiveDB')
		client[:events].delete_many({})
		client.close
	end
end


