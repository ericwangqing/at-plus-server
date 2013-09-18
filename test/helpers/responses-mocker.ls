require! ['./utils'.load-fixture, '../bin/users-manager', '../bin/interesting-points-manager', '../bin/locations-manager']

mock-locations-channel-initial-response = (location-id, current-uid)->
  locations = locations-manager.create-locations-for-response load-fixture "locations-in-db"
  interesting-points-summaries-map = interesting-points-manager.create-interesting-points-summaries-map load-fixture "interesting-points-in-db"
  replace-uid-with-brief-user interesting-points-summaries-map, current-uid
  response = (locations.filter (location)-> location._id is location-id)[0]
  response.interesting-points-summaries = interesting-points-summaries-map[location-id]
  response 

replace-uid-with-brief-user = !(interesting-points-summaries-map, current-uid)->
  brief-users-map = users-manager.create-brief-users-map (load-fixture 'users-in-db'), current-uid
  interesting-points-manager.visit-uids-of-interesting-points-summaries-map interesting-points-summaries-map, !(value, attr)->
    value[attr] = brief-users-map[value[attr]]

module.exports = 
  mock-locations-channel-initial-response: mock-locations-channel-initial-response