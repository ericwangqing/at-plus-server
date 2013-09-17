require! ['./database']
_ = require 'underscore'


resolve-locations = !(request-locations, callback)->
  (db) <-! database.get-db
  (err, locations) <-! db.at-plus.locations.find {urls: "$in": request-locations.urls} .to-array
  inexistence-locations-urls = find-inexistence-locations request-locations.urls, locations
  callback (clean-locations-for-response locations), inexistence-locations-urls

find-inexistence-locations = (all-urls, locations)->
  exist-urls = _.reduce locations, (memo, location)-> 
    memo.concat location.urls
  , memo = []
  [url for url in all-urls when url not in exist-urls]

update-location = !(lid, update-data, callback)->
  debug '********* update-location 尚未实现 **************'
  callback!

clean-locations-for-response = (locations)->
  locations.for-each !(location)->
    delete location.duration
    delete location.retrieved-html
  locations


create-location = !(url, callback)->
  # !! 未实现。提醒注意，要查询url的别名，也就是多个其它url，其实指向了同一个网页。特别是此时其它@+已经打开了这样的别名网页，如果
  # 没有判断好，那些用户将收不到此页面上的兴趣点。

module.exports =
  resolve-locations: resolve-locations
  update-location: update-location
  clean-locations-for-response: clean-locations-for-response # !!暴露出来，仅仅是为了测试
