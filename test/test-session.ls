io = require 'socket.io-client'
require! './patch-io-client-with-session.spec'.patch-io-client-with-session

base-url = 'http://localhost:3000'
options = 
  transports: ['websocket']
  'force new connection': true

can = it # it在LiveScript中被作为缺省的参数，因此我们先置换为can

describe '能够通过session区分不同的用户', !->
  before !(done)->
    patch-io-client-with-session base-url, done

  can '在同一个用户多次请求之间保存状态', !(done)->
    client1 = io.connect base-url, options

    client1.on 'initial', !(data)->
      console.log 'data: ', data
      data.session.client.should.eql 'client1'
      client1.emit 'request-1', null 

    client1.on 'request-1-answer', !(data)->
      console.log 'data: ', data
      data.session.client.should.eql 'client1'
      done!


