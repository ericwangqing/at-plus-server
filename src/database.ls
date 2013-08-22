# mockable Singleton
client = connection = null

init-mongo-client = !(callback)->
	client = new MongoClient new Server config.mongo.host, config.mongo.port
	(err, opened-client) <-! client.open
	connection = client.db config.mongo.db
	load-collections connection config.mongo.db
	callback!

load-collections = !(collections)->
	for c in collections
		connection[c] = client.collection c

shutdown-mongo-client = !(callback)->
	client.close!
	callback!

init-mongo-client!

moudle.exports <<< {
	get-db-connection: ->
		connection
	shutdown-mongo-client: shutdown-mongo-client
}