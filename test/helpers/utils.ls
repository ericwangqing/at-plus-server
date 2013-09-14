require! '../bin/database'
debug = require('debug')('at-plus')

FIXTURE_PATH = __dirname + '/../test-bin/' # 这样写，是因为在开发时，src目录中的代码也会使用。

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

  @get = (socket)->
    instance ?:= new Destroyer socket

class All-done-waiter
  CHECK_INTERVAL = 50
  running-functions = 0

  !(@done)->

  get-wating-function: (fn)->
    running-functions += 1
    !->
      fn.apply null, arguments if fn
      running-functions -= 1

  start: !->
    timer = set-interval check = ~>
      if running-functions is 0
        clear-interval timer
        @done!

    , CHECK_INTERVAL


module.exports =
  load-fixture: (data-name)->
    eval require('fs').readFileSync(FIXTURE_PATH + data-name + '.js', {encoding: 'utf-8'}) 

  open-clean-db-and-load-fixtures: !(collection-name, docs, done)->
    (db) <-! database.get-db
    <-! db.drop-database
    (err, docs) <-! db.at-plus.[collection-name].insert docs
    throw new Error err if err
    done!

  close-db: !(done)->
    (db) <-! database.get-db
    database.shutdown-mongo-client done

  All-done-waiter: All-done-waiter
  Sockets-distroyer: Sockets-distroyer
