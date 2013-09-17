require! [async, '../bin/database', '../bin/interesting-points-manager', '../bin/locations-manager']
debug = require('debug')('at-plus')
_ = require 'underscore'

FIXTURE_PATH = __dirname + '/../test-bin/' # 这样写，是因为在开发时，src目录中的代码也会使用。

#------------------- Utility Classes ------------------#
class Sockets-distroyer # Singleton
  instance = null

  class Destroyer
    !->
      @client-sockets = []
    add-socket: !(socket)->
      @client-sockets.push socket
    destroy-all: !->
      for socket in @client-sockets
        socket = socket.socket if socket.socket # 当socket.io 连接到有namespace的情况要用socket.socket.disconnect!
        socket.disconnect!
      @client-sockets = []

  @get = (socket)->
    instance ?:= new Destroyer socket

class All-done-waiter
  !(@done)->
    @running-functions = 0

  add-wating-function: (fn)->
    @running-functions += 1
    !~>
      fn.apply null, arguments if fn
      @running-functions -= 1
      @check!

  check: !~>
    @done! if @running-functions is 0

#------------------- Utility Functions ------------------#

load-fixture = (data-name)->
  eval require('fs').readFileSync(FIXTURE_PATH + data-name + '.js', {encoding: 'utf-8'}) 


open-clean-db-and-load-fixtures = !(config, done)->
  (db) <-! database.get-db
  <-! db.drop-database
  collections = _.keys config
  async.each collections, !(collection, next)->
    (err, docs) <-! db.at-plus.[collection].insert config[collection]
    next!
  ,
  done!

prepare-clean-test-db = !(done)->
  locations = load-fixture "locations-in-db"
  interesting-points = load-fixture "interesting-points-in-db"
  open-clean-db-and-load-fixtures {
    'locations': locations
    'interesting-points': interesting-points
  }, done

close-db = !(done)->
  (db) <-! database.get-db
  database.shutdown-mongo-client done

chop-off-id = (obj)-> # 从服务端得回的数据，常常包括了由mongoDB生成的_id，不应当包括在数据的比较中，需要清洗。
  if _.is-array obj
    for item in obj
      chop-off-id item
  else
    if typeof obj is 'object'
      delete obj._id
      for key in _.keys obj
        chop-off-id obj[key]
  obj

get-test-initial-locations-response = (location-id)->
  locations = locations-manager.clean-locations-for-response load-fixture "locations-in-db"
  interesting-points = interesting-points-manager.clean-ips-for-response load-fixture "interesting-points-in-db"
  response = (locations.filter (location)-> location._id is location-id)[0]
  response.interesting-points-summaries = interesting-points[location-id]
  response 


module.exports =
  All-done-waiter: All-done-waiter
  Sockets-distroyer: Sockets-distroyer
  load-fixture: load-fixture
  open-clean-db-and-load-fixtures: open-clean-db-and-load-fixtures
  prepare-clean-test-db: prepare-clean-test-db
  close-db: close-db
  chop-off-id: chop-off-id
  get-test-initial-locations-response: get-test-initial-locations-response
