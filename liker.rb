#! /usr/bin/ruby 

require './util.rb'
require 'json'
require 'koala'  # Facebook API

# Config
SECRET_PATH = "./env.json"
MAX_TO_PROCESS = 1000  # maximum number of posts we expect to process
BIRTHDAY_DAY = 13  # 1..31
BIRTHDAY_MONTH = 8  # 1..12


if !(File.exists? SECRET_PATH)
    abort("No env file (with the access token).".red)
end

begin
    env_json = JSON.parse File.read(SECRET_PATH)
rescue JSON::ParserError
    abort("Invalid env json".red)
end
ACCESS_TOKEN = env_json['access_token']
$graph = Koala::Facebook::API.new(ACCESS_TOKEN)

# getting a timestamps before and after the birthday
current_year = Time.now.year
tstamp_before = Time.new(current_year, BIRTHDAY_MONTH, BIRTHDAY_DAY - 1, 12, 0).to_i
tstamp_after = Time.new(current_year, BIRTHDAY_MONTH, BIRTHDAY_DAY + 1, 12, 0).to_i

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

