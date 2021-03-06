require! {async, '../bin/database', '../bin/config'}
debug = require('debug')('at-plus')
_ = require 'underscore'

FIXTURE_PATH = __dirname + '/../test-bin/' # 这样写，是因为在开发时，src目录中的代码也会使用。

#------------------- Utility Classes ------------------#
class All-done-waiter
  !(@done)->
    @running-functions = 0

  set-done: (done)~>
    @done = done

  add-waiting-function: (fn)~>
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
    (err, docs) <-! db.at-plus.[collection].insert config[collection], {safe: true}
    next!
  , ->
    done!

prepare-clean-test-db = !(done)->
  locations = load-fixture "locations-in-db"
  interesting-points = load-fixture "interesting-points-in-db"
  users = load-fixture "users-in-db"
  messages = load-fixture "messages-in-db"
  open-clean-db-and-load-fixtures {
    'locations': locations
    'interesting-points': interesting-points
    'users': users
    'messages': messages
  }, done

close-db = !(done)->
  (db) <-! database.get-db
  database.shutdown-mongo-client done

count-amount-of-docs-in-a-collection = !(collection-name, callback)->
  (results) <-! database.query-collection collection-name, {}
  callback results.length

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


module.exports =
  All-done-waiter: All-done-waiter
  load-fixture: load-fixture
  open-clean-db-and-load-fixtures: open-clean-db-and-load-fixtures
  prepare-clean-test-db: prepare-clean-test-db
  close-db: close-db
  count-amount-of-docs-in-a-collection: count-amount-of-docs-in-a-collection
  chop-off-id: chop-off-id
