debug = require('debug')('at-plus')
require! ['./interesting-points-manager', './channel-initial-wrapper']
module.exports = 
	init: !(io)->
		channel-initial-wrapper.server-channel-initial-wrapper {
			channel: io.of '/interesting-points'

			business-handlers-register: !(socket, data, callback)->
				socket.on 'request-new-interesting-point-comment', !(data, done)->
					(result) <-! interesting-points-manager.create-comment data
					socket.emit 'request-new-interesting-point-comment', result
					done!
				callback err = null, {}
			}
