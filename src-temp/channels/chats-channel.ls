debug = require('debug')('at-plus')
module.exports  = 

	init: !(io)->
		io.of('/chats-channel').on 'connection', !(socket)->
			console.info 'chats-channel connected'
			socket.emit 'a message', {everyone: 'in', '/chats': 'will get'}

