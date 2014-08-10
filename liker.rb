#! /usr/bin/ruby 

require './util.rb'
require 'json'
require 'koala'  # Facebook API

SECRET_PATH = "./.env.json"
if !(File.exists? SECRET_PATH)
    abort("No env file (with app_id and app_secret present.".red)
end

begin
    env_json = JSON.parse File.read(SECRET_PATH)
rescue JSON::ParserError
    abort("Invalid env json".red)
end
APP_ID = env_json["app_id"]
APP_SECRET = env_json["app_secret"]

