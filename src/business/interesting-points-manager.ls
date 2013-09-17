require! './database'
_ = require 'underscore'

get-interesting-points-summaries = !(locations-ids, callback)->
  (db) <-! database.get-db
  (err, ips) <-! db.at-plus['interesting-points'].find {'withinLocation.lid': "$in": locations-ids} .to-array
  # debug 'get-interesting-points-summaries: ', ips.length
  callback clean-ips-for-response ips

clean-ips-for-response = (ips)->
  result = {}
  for ip in ips
    result[ip.within-location.lid] ||= [] 
    result[ip.within-location.lid].push summarize ip
  result


summarize = (ip)->
  if ip.type is 'web'
    ip.position-within-web-page = ip.within-location.at-position.position-within-web-page
    delete ip.within-location
  else # type is 'real'
    debug '****************** 未实现 ***************'
  delete ip.type
  ip


module.exports =
  get-interesting-points-summaries: get-interesting-points-summaries
  clean-ips-for-response: clean-ips-for-response # !!暴露出来，仅仅是为了测试