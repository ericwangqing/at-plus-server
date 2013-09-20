require! './database'
_ = require 'underscore'

get-interesting-points-summaries-map = !(locations-ids, callback)->
  (db) <-! database.get-db
  (err, ips) <-! db.at-plus['interesting-points'].find {'withinLocation.lid': "$in": locations-ids} .to-array
  # debug 'get-interesting-points-summaries-map: ', ips.length
  callback create-interesting-points-summaries-map ips

create-interesting-points-summaries-map = (ips)->
  result = {}
  for ip in ips
    result[ip.within-location.lid] ||= [] 
    result[ip.within-location.lid].push summarize ip
  result

visit-uids-of-interesting-points-summaries-map = !(interesting-points-summaries-map, visitor)->
  attributes-with-uid = ['createdBy', 'commentedBy', 'sharedWith', 'watchedBy']
  for ips-array in _.values interesting-points-summaries-map
    for ips in ips-array
      for attr in attributes-with-uid
        value = ips[attr]
        if _.is-array value
          for uid, i in value
            visitor value, i
          ips[attr] = _.compact value # 去除null和undefined 
        else
          visitor ips, attr

summarize = (ip)->
  if ip.type is 'web'
    ip.position-within-web-page = ip.within-location.at-position.position-within-web-page
    delete ip.within-location
  else # type is 'real'
    debug '****************** 未实现 ***************'
  delete ip.type
  ip

create-interesting-point = !(location-id, interesting-point-data, callback)->
  debug "------ in: 'create-interesting-point' ---------"
  callback {}



module.exports =
  get-interesting-points-summaries-map: get-interesting-points-summaries-map
  visit-uids-of-interesting-points-summaries-map: visit-uids-of-interesting-points-summaries-map
  create-interesting-point: create-interesting-point
  create-interesting-points-summaries-map: create-interesting-points-summaries-map # !!暴露出来，仅仅是为了测试