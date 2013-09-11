describe 'session测试', !->
  can '每次处理业务逻辑后能够保存session', !(done) ->
    sid = message = null
    request-server {
      url: base-url
    },
    !(client, initial-data)->
      sid := initial-data.sid
      message = initial-data.message

      do
        (data) <-! client.on 'change-session-response'
        client.disconnect!

        request-server {
          url: base-url
          request-initial-data:
            sid: sid
        },
        !(client, initial-data)->
          initial-data.message.should.not.eql message
          done!
      client.emit 'change-session-request', null
