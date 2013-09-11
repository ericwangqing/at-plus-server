debug = require('debug')('at-plus')
# mockable Singleton
require! ['mongodb'.Db, 'mongodb'.Server, 'mongodb'.MongoClient, './config']

db = null

init-mongo-client = !(callback)->
<<<<<<< HEAD
  client := new MongoClient new Server config.mongo.host, config.mongo.port
  (err, opened-client) <-! client.open
  connection := client.db config.mongo.db
  # console.log 'connection.collection: ', connection.collection
  load-collections connection, config.mongo.collections
  callback!
=======
  if db
    callback!
  else
    # debug "create connection"
    db := new Db config.mongo.db, (new Server config.mongo.host, config.mongo.port), w: config.mongo.write-concern
    (err, db) <-! db.open

    load-collections db, config.mongo.collections
    callback!
>>>>>>> upstream/master

load-collections = !(db, collections)->
  for c in collections
    # debug "add collection: #{c} in db"
    db.at-plus = {}
    db.at-plus[c] = db.collection c

shutdown-mongo-client = !(callback)->
  db.close!
  db := null
  callback!
  
__set-mock-db = !(mock-db)->
  db = mock-db


module.exports =
  get-db: !(callback)->
    if !db
      <-! init-mongo-client
      callback db
    else
      callback db

<<<<<<< HEAD
    connection
  shutdown-mongo-client: shutdown-mongo-client
}
=======
  shutdown-mongo-client: shutdown-mongo-client
>>>>>>> upstream/master
