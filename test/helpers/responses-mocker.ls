require! ['./utils'.load-fixture, '../bin/config', '../bin/messages-manager', '../bin/users-manager',
   '../bin/interesting-points-manager', '../bin/locations-manager']
debug = require('debug')('at-plus')
_ = require 'underscore'

mock-locations-channel-initial-response = (location-id, current-uid)->
  locations = locations-manager.create-locations-for-response load-fixture "locations-in-db"
  interesting-points-summaries-map = interesting-points-manager.create-interesting-points-summaries-map load-fixture "interesting-points-in-db"
  recent-messages-map = messages-manager.create-brief-recent-messages-map sort-messages load-fixture "messages-in-db"
  response = (locations.filter (location)-> location._id is location-id)[0]
  add-brief-user-and-interesting-points-summaries-with-messages response, current-uid, location-id, interesting-points-summaries-map, recent-messages-map
  response 

sort-messages = (messages)->
  _.sort-by messages, 'createTime' .reverse! 

add-brief-user-and-interesting-points-summaries-with-messages = !(response, current-uid, location-id, interesting-points-summaries-map, recent-messages-map)->
  replace-uid-with-brief-user interesting-points-summaries-map, current-uid
  response.interesting-points-summaries = interesting-points-summaries-map[location-id]
  for ips in response.interesting-points-summaries
    ips.recent-messages = recent-messages-map[ips._id]

replace-uid-with-brief-user = !(interesting-points-summaries-map, current-uid)->
  brief-users-map = users-manager.create-brief-users-map (load-fixture 'users-in-db'), current-uid
  interesting-points-manager.visit-uids-of-interesting-points-summaries-map interesting-points-summaries-map, !(value, attr)->
    value[attr] = brief-users-map[value[attr]]

module.exports = 
  mock-locations-channel-initial-response: mock-locations-channel-initial-response