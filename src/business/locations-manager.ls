'''
FAKE 假实现，需要更换成为真正的实现。
'''
require! ['../test-bin/utils', './database']

resolve-locations = !(request-locations, callback)->
  (db) <-! database.get-db
  (err, locations) <-! db.at-plus.locations.find {ulrs: $in: request-locations} .to-array
  debug 'locations: ', locations
  callback err || locations

module.exports =
  resolve-locations: resolve-locations
