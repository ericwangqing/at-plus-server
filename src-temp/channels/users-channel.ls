debug = require('debug')('at-plus')
module.exports  = 

	init: !(io)->
		io.of('/users-channel').on 'connection', !(socket)->
			console.log 'users-channel connected'
			socket.emit 'a message', {everyone: 'in', '/users': 'will get'}

