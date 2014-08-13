#! /usr/bin/ruby 

require './util.rb'
require 'json'
require 'koala'  # Facebook API

SECRET_PATH = "./config.json"

if !(File.exists? SECRET_PATH)
    abort("No config file (with the access token).".red)
end

begin
    env_json = JSON.parse File.read(SECRET_PATH)
rescue JSON::ParserError
    abort("Invalid config json".red)
end
B_DAY = env_json['birth_day']
B_MONTH = env_json['birth_month'] 
# maximum number of posts we expect to process
MAX_TO_PROCESS = 1000
ACCESS_TOKEN = env_json['access_token']

$graph = Koala::Facebook::API.new(ACCESS_TOKEN)

# getting a timestamps before and after the birthday
current_year = Time.now.year
tstamp_before = Time.new(current_year, B_MONTH, B_DAY - 1, 12, 0).to_i
tstamp_after = Time.new(current_year, B_MONTH, B_DAY + 1, 12, 0).to_i

FQL_QUERY =
    "SELECT source_id, actor_id, post_id, created_time, message "\
    "FROM stream "\
    "WHERE source_id = me() "\
        "AND filter_key = 'others' "\
        "AND actor_id != me() "\
        "AND created_time > #{tstamp_before} "\
        "AND created_time < #{tstamp_after} "\
    "LIMIT #{MAX_TO_PROCESS}"

begin
    q_results = $graph.fql_query(FQL_QUERY)
rescue Koala::Facebook::AuthenticationError
    abort("Authentication token is not valid. Maybe expired?").red
end

puts "#{q_results.length} posts to process".green.bold

for postJSON in q_results
    post_id = postJSON['post_id']
    $graph.put_like(post_id)
    sleep 0.2;  # we are not bots, so we sleep 
    puts "LIKE: ".green + postJSON['message']
    $stdout.flush
end

puts "Done.".bold.green

