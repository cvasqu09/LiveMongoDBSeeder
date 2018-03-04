require 'roo'
require 'json'
require 'byebug'

def create_json(keys, row)
	json_obj = {}

	keys.each_with_index do |key, index|
		json_key = nil
		values = nil
		if key.include?('_array')
			json_key = key.gsub("_array", "")
			values = row[index].to_s.split(',')
			values.each { |e| e.strip! }
			json_obj[json_key] = values
		else 
			next if row[index] == nil
			json_key = key
			value = row[index]
			json_obj[json_key] = value
		end
	end
	

	json_obj
end

paths = { "events" => 'C:/Users/Chris/Documents/Git Repos/LiveMongoDBSeeder/events.xlsx' }

paths.each do |name, path|
	xlsx = Roo::Spreadsheet.open(path)
	xlsx.default_sheet = xlsx.sheets[0]


	json_file = File.open("#{name}.json", "w+")

	count = 1
	json_objs = []
	keys = []
	xlsx.each do |row|
		if count == 1
			keys = row
		else
			obj = create_json(keys, row)
			json_objs.push(obj)
		end
		count = count + 1
	end

	json_file.write(JSON.pretty_generate(json_objs))
end

