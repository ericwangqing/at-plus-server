'''
用于测试，帮助BDD时，通过向此频道发送数据，初始化服务端的测试。
！！正式发布时，需要去掉。
'''
testing-control = null

require! ['./channel-initial-wrapper']
module.exports = 
  init: !(io)->
    channel-initial-wrapper.server-channel-initial-wrapper {
      channel: io.of('/testing-helper')

      request-initial-handler: !(socket, data, callback)->
        # 在这里，将测试客户端发过来的数据存储到session中，以便使用。
        socket.session.uid = data.fake-uid if data.fake-uid
        testing-control := data.testing-control if data.testing-control
        # debug "testing-helper-channel: request-initial-handler, session: ", socket.session
        callback!
    }

  get-testing-control: ->
    testing-control


