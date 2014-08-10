#! /usr/bin/ruby 

require './util.rb'
require 'json'
require 'koala'  # Facebook API

SECRET_PATH = "./.env.json"
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

FQL_QUERY = "SELECT post_id, actor_id, target_id, created_time, message, comments FROM stream 
WHERE source_id = me() AND filter_key='others' AND actor_id!=me() AND created_time > 1407275080"
q_results = $graph.fql_query(FQL_QUERY)


