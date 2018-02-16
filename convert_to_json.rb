require 'roo'
require 'json'
require 'byebug'

def create_json(keys, row)
	event = {}

	keys.each_with_index do |key, index|
		json_key = nil
		values = nil
		if key.include?('_array')
			json_key = key.gsub("_array", "")
			values = row[index].split(',')
			values.each { |e| e.strip! }
			event[json_key] = values
		else 
			next if row[index] == nil
			json_key = key
			value = row[index]
			event[json_key] = value
		end
	end
	

	event
end

path = 'C:/Users/Chris/Documents/Git Repos/LiveMongoDBSeeder/events.xlsx'

xlsx = Roo::Spreadsheet.open(path)
xlsx.default_sheet = xlsx.sheets[0]


events_json_file = File.open('events.json', "w+")

count = 1
events = []
keys = []
xlsx.each do |row|
	if count == 1
		keys = row
	else
		event = create_json(keys, row)
		events.push(event)
	end
	count = count + 1
end
byebug

events_json_file.write(JSON.pretty_generate(events).delete('\\'))

