io = require 'socket.io-client'
# patch = require './patch-io-client-with-session'
require! {should, async, _: underscore, '../bin/channels-initial-helper'}
debug = require('debug')('at-plus')

base-url = 'http://localhost:3000'
options = 
  # transports: ['websocket']
  'force new connection': true
  'reconnect': false

can = it # it在LiveScript中被作为缺省的参数，因此我们先置换为can

request-server = !(business-handlers, alter-option) ->
  channels-initial-helper.client-initial-wrapper {
    io: io
    url: base-url
    options: options
    business-handlers: !(client, response-initial-data, initial-callback)->
      business-handlers client, response-initial-data
      initial-callback!
  } <<< alter-option
  
