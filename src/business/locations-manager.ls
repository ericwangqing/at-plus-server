require! ['./database', './web-monitor']
event-bus = require './event-bus'
_ = require 'underscore'


resolve-locations = !(request-locations, callback)->
  urls = if (request-locations and request-locations.urls) then request-locations.urls else []
  (locations) <-! database.query-collection 'locations',  {urls: "$in": urls}
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

create-or-update-a-location = !(session-id, url-data, callback)->
  debug "------ in: 'create-or-update-a-location' ---------"
  (is-new, location) <-! get-old-or-create-new-location url-data
  if is-new
    debug "********* emit: 'ask-location-internality' *********"
    event-bus.emit 'locations-channel:ask-location-internality', 
      session-id: session-id
      lid: location._id
      url: url-data.url
      server-retrieved-html: location.server-retrieved-html
    callback location
  else
    callback location

get-old-or-create-new-location = !(url-data, callback)->
  debug "------ in: 'get-old-or-create-new-location' ---------"
  (found-location, new-web-page) <-! web-monitor.find-location-for-url url-data
  if found-location
    found-location.urls.push url-data.url
    (db) <-! database.get-db
    (err, location) <-! db.at-plus.locations.save found-location
    callback false, found-location
  else
    current-time = new Date!
    (db) <-! database.get-db
    (err, locations) <-! db.at-plus.locations.insert {
      type: 'web'
      name: url-data.name
      is-existing: true
      is-internal: false #此为默认值，随后会让客户端协助查询，如果为internal，则更新为true
      duration: 
        from: current-time
        to: current-time
      urls: [url-data.url]
      server-retrieved-html: new-web-page.retrieved-html
    }
    place-web-page-snapshot new-web-page.snapshot, locations[0]._id
    callback true, locations[0]

place-web-page-snapshot = !(snapshot, lid)->
  debug "*************** place-web-page-snapshot 尚未实现 ***************"
  # 将snapshot，放到恰当位置，能够通过 /web-page-snapshot/lid 访问

update-location-internality = !(lid, is-internal, callback)->
  debug "------ in: 'update-location-internality' ---------"
  callback! if callback

update-location-with-ip = !(session-id, url, location, interesting-point-summary, callback)->
  debug "------ in: 'update-location-with-ip' ---------"
  debug "------ emit: 'locations-channel:location-updated' ---------"
  event-bus.emit 'locations-channel:location-updated',
    session-id: session-id
    url: url
    location: location
    interesting-point-summary: interesting-point-summary

  callback! if callback

get-location-by-id = !(lid, callback)->
  debug "------ in: 'get-location-by-id' ---------"
  callback {_id: Math.random!}




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
