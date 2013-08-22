# mockable Singleton
require! ['mongodb'.Server, 'mongodb'.MongoClient, './config']

client = connection = null

init-mongo-client = !(callback)->
  client := new MongoClient new Server config.mongo.host, config.mongo.port
  (err, opened-client) <-! client.open
  connection := client.db config.mongo.db
  console.log 'connection.collection: ', connection.collection
  load-collections connection, config.mongo.collections
  callback!

load-collections = !(connection, collections)->
  for c in collections
    connection[c] = connection.collection c

shutdown-mongo-client = !(callback)->
  client.close!
  callback!
  
__set-mock-db-connnection = !(mock-db-connnection)->
  connection = mock-db-connnection


module.exports <<< {
  get-db-connection: (callback)->
    if !connection
      <-! init-mongo-client
      callback connection
    else
      callback connection

    connection
  shutdown-mongo-client: shutdown-mongo-client
}