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

module.exports =
  load-fixture: (data-name)->
    eval require('fs').readFileSync(FIXTURE_PATH + data-name + '.js', {encoding: 'utf-8'}) 

  open-db-and-load-fixtures: !(collection-name, docs, done)->
    (db) <-! database.get-db
    (err, docs) <-! db.at-plus.[collection-name].insert docs
    throw new Error err if err
    done!

  clear-and-close-db: !(done)->
    (db) <-! database.get-db
    <-! db.drop-database
    database.shutdown-mongo-client done

  All-done-waiter: All-done-waiter
  Sockets-distroyer: Sockets-distroyer
