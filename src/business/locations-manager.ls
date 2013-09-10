'''
FAKE 假实现，需要更换成为真正的实现。
'''
require! ['../test-bin/utils', './database']
debug = require('debug')('at-plus')

resolve-locations = !(request-locations, callback)->
  (db-connection) <-! database.get-db-connection
  # console.log 'request-locations is: ', request-locations
  (err, locations) <-! db-connection.locations.find {
    type: request-locations.type
    urls: {$in: request-locations.urls}
  } .to-array
  callback locations

module.exports =
  resolve-locations: resolve-locations
