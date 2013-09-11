debug = require('debug')('at-plus')
'''
FAKE 假实现，需要更换成为真正的实现。
'''
require! ['../test-bin/utils', './database']
<<<<<<< HEAD
debug = require('debug')('at-plus')

resolve-locations = !(request-locations, callback)->
  (db-connection) <-! database.get-db-connection
  # console.log 'request-locations is: ', request-locations
  (err, locations) <-! db-connection.locations.find {
    type: request-locations.type
    urls: {$in: request-locations.urls}
  } .to-array
  callback locations
=======

resolve-locations = !(request-locations, callback)->
  (db) <-! database.get-db
  (err, locations) <-! db.at-plus.locations.find!.to-array
  callback err || locations

>>>>>>> upstream/master

module.exports =
  resolve-locations: resolve-locations
