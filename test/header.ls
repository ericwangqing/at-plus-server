'''
测试文件的头部。本文件代码在项目编译前，被添加到所有测试代码（test**.ls）的最前面。这样，避免了在多个测试文件中写一样的头部。
'''

io = require 'socket.io-client'
# patch = require './patch-io-client-with-session'
require! {should, async, _: underscore, './utils', './responses-mocker', '../bin/channel-initial-wrapper', '../bin/server'}
debug = require('debug')('at-plus')

base-url = 'http://localhost:3000'
options = 
  # transports: ['websocket']
  'force new connection': true
  'reconnect': false

can = it # it在LiveScript中被作为缺省的参数，因此我们先置换为can

request-server = !(alter-option, business-handlers-register) ->
  channel-initial-wrapper.client-channel-initial-wrapper {
    io: io
    url: base-url
    options: options
    business-handlers-register: !(client, response-initial-data, initial-callback)->
      business-handlers-register client, response-initial-data
      initial-callback!
  } <<< alter-option
  
