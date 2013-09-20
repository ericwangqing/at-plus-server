describe '测试在新URL上创建新兴趣点时，Locations Channel与Interesting Points Channel的协同', !->
  describe '创建的整个流程，有按照http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=221184007的设计进行', !->
    can '提交创建请求后，按照设计，服务端各模块执行了流程', !(done)->
      debug '''
      ************ 请注意，本测例需要人工观察，判断是否正确 **************
      注意：服务端应该依http://my.ss.sysu.edu.cn/wiki/pages/viewpage.action?pageId=221184007次输出各步骤的执行
      '''
      open-at-plus-on-interesting-points-channel !(ip-channel, data)->
        ip-channel.on 'response-create-a-new-ip-on-a-new-url', !(data)->
          done!
        ip-channel.emit 'request-create-a-new-ip-on-a-new-url'



  before-each !(done)->
    <-! server.start
    (require 'socket.io-client/lib/io.js').sockets = {} # the cache in it should be clear before each running, otherwise the connection will be reused, even if you restart the server!
    utils.prepare-clean-test-db done
    debug 'prepare-clean-test-db complete'

  after-each !(done)->
    utils.close-db !->
      utils.Sockets-distroyer.get!.destroy-all!
      server.shutdown!
      done!

# ---------------------- 美丽的分割线，以下辅助代码 ----------------------- #

locations-channel-url = base-url + "/locations"
interesting-points-channel-url = base-url + "/interesting-points"

open-at-plus-on-interesting-points-channel = !(callback)->
  request-server url: interesting-points-channel-url
  ,
  !(socket, initial-data)->
    utils.Sockets-distroyer.get!.add-socket socket # 为了在每个测试结束，关闭服务端的socket，以便隔离各个测例。
    callback socket, initial-data
