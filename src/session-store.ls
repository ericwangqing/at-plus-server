'''
在同一用户连接多个channels时，保持跨channels的session。可以配置为in-memory，或者redis的。当为redis的时候，需要先运行redis服务器。
'''

require! redis

session-store-type = 'in-momery'
redis-store = null
in-momery-session-store = {}

module.exports = 
  config: !(cfg)->
    if cfg.session-store-type in ['in-momery', 'redis']
      session-store-type := cfg.session-store-type
    redis-store = redis.create-client() if cfg.session-store-type is 'redis'

  get-session: !(socket, callback)->
    console.log 'session-store-type: ', session-store-type
    if session-store-type is 'redis'
      redis-store.get 'socket.id', !(err, result)->
        if err
          console.log "can't retrive #{socket.id} from redis, with err: ", err
        else
          session = (JSON.parse result) or {} 
          session.save = !(done)->
            redis-store.set 'socket.id', (JSON.stringify session), !(err, result)->
              if err
                console.log "can't save key: #{socket.id}, value: #{JSON.stringify session} to redis with err: ", err
              else
                done!
        callback session
    else if session-store-type is 'in-momery'
      session = in-momery-session-store[socket.id] or {}
      session.save = !(done)->
        in-momery-session-store[socket.id] = session
        done! 
      callback session
