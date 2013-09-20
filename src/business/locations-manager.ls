require! ['./database']
event-bus = require './event-bus'
_ = require 'underscore'


resolve-locations = !(request-locations, callback)->
  (db) <-! database.get-db
  urls = if (request-locations and request-locations.urls) then request-locations.urls else []
  (err, locations) <-! db.at-plus.locations.find {urls: "$in": urls} .to-array
  inexistence-locations-urls = find-inexistence-locations urls, locations
  callback (create-locations-for-response locations), inexistence-locations-urls

find-inexistence-locations = (all-urls, locations)->
  exist-urls = _.reduce locations, (memo, location)-> 
    memo.concat location.urls
  , memo = []
  [url for url in all-urls when url not in exist-urls]

update-location = !(lid, update-data, callback)->
  debug '********* update-location 尚未实现 **************'
  callback!

create-locations-for-response = (locations)->
  [_.omit location, 'duration', 'retrievedHtml' for location in locations]

create-or-update-a-location = !(url, callback)->
  debug "------ in: 'create-or-update-a-location' ---------"
  (is-new, location) <-! get-old-or-create-new-location url
  if is-new
    debug "********* emit: 'ask-location-internality' *********"
    event-bus.emit 'locations-channel:ask-location-internality', 
      lid: location._id
      server-retrieved-html: location.server-retrieved-html
    callback location
  else
    callback location

get-old-or-create-new-location = !(url, callback)->
  debug "------ in: 'get-old-or-create-new-location' ---------"
  location = {}
  is-new = if Math.random! < 0.5 then true else false
  callback is-new, location

update-location-internality = !(lid, is-internal, callback)->
  debug "------ in: 'update-location-internality' ---------"
  callback! if callback

update-location-with-ip = !(url, lid, interesting-point, callback)->
  debug "------ in: 'update-location-with-ip' ---------"
  (location) <-! get-location-by-id lid
  debug "------ emit: 'locations-channel:location-updated' ---------"
  event-bus.emit 'locations-channel:location-updated',
    url: url
    location: location
    ip-summary: {}

  callback! if callback

get-location-by-id = !(lid, callback)->
  debug "------ in: 'get-location-by-id' ---------"
  callback {}




create-location = !(url, callback)->
  # !! 未实现。提醒注意，要查询url的别名，也就是多个其它url，其实指向了同一个网页。特别是此时其它@+已经打开了这样的别名网页，如果
  # 没有判断好，那些用户将收不到此页面上的兴趣点。

module.exports =
  resolve-locations: resolve-locations
  update-location: update-location
  create-or-update-a-location: create-or-update-a-location
  update-location-with-ip: update-location-with-ip
  update-location-internality: update-location-internality
  create-locations-for-response: create-locations-for-response # !!暴露出来，仅仅是为了测试
