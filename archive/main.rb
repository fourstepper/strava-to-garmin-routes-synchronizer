#!/usr/bin/env ruby

require 'strava-ruby-client'
require 'json'

strava_access_token = ENV["STRAVA_ACCESS_TOKEN"]

if strava_access_token.length > 0
  client = Strava::Api::Client.new(access_token: strava_access_token)
end

def get_strava_routes(client)
  routes = []
  client.athlete_routes(id: client.athlete.id, per_page: 100) do |route|
    routes << route
  end
  return routes
end

# puts get_strava_routes(client).to_json

=begin
PROGRAM STEPS
1. read all current routes from the Strava API
2. compare the current ones with the ones that we have saved in the DB
  - if the Strava route isn't in the DB, we INSERT it into the DB
    - fields: id, name, updated_at
  - if some route with the same name already exists, we check route["updated_at"] against the DB
    - if it's the same, we do nothing
    - if it's not the same, we mark it for UPDATE
  - if we have a route in the DB that isn't in Strava anymore, we mark it for DELETE
    - this marks the route for deletion in the DB
    - deletes the route from Garmin Connect
    - deletes the route from DB
=end

routes = JSON.parse(File.read('strava-routes.json'))

routes.each do |route|
  print "Route name: #{route['name']},  Updated at: #{route['updated_at']}\n"
end
