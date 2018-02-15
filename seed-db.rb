require 'roo'
require 'json'
require 'byebug'
require 'mongo'
require 'rest-client'

class MongoSeeder

	def initialize(path_to_excel)
		@xlsx = Roo::Spreadsheet.open(path_to_excel)
		@xlsx.default_sheet = @xlsx.sheets[0]
	end

	def seed_events
		clear_events_db()
		count = 1
		keys = []
		@xlsx.each do |row|
			if count == 1
				keys = row
			else 
				request_body = create_request_body(keys, row)
				post_event(request_body)
			end
			count = count + 1
		end
	end

	private 

	def create_request_body(keys, row)
		request = {}

		keys.each_with_index do |key, index|
			json_key = nil
			values = nil
			if key.include?('_array')
				json_key = key.gsub("_array", "")
				values = row[index].split(',')
				values.each { |e| e.strip! }
				request[json_key] = values
			else 
				next if row[index] == nil
				json_key = key
				value = row[index]
				request[json_key] = value
			end
		end
		request.to_json
	end

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

seeder = MongoSeeder.new('./events.xlsx')
seeder.seed_events


