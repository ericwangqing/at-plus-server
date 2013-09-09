'''
在同一用户连接多个channels时，保持跨channels的session。可以配置为in-memory，或者redis的。当为redis的时候，需要先运行redis服务器。
'''

require! redis

type = 'in-memory'
redis-store = null
memory-store = {}

get-in-memory = !(sid, fn)->
  fn and fn(memory-store[sid] or {})

set-in-memory = !(sid, session, fn)->
  fn and fn(memory-store[sid] = session)

restore-in-memory = !(new-sid, old-sid, fn)->
  if memory-store[old-sid]
    memory-store[new-sid] = memory-store[old-sid]
    memory-store[new-sid].sid = new-sid
    delete memory-store[old-sid]
  fn memory-store[new-sid]

get-in-redis = !(sid, fn)->
  redis-store.get sid, !(err, result)->
    if err then fn(err) else fn((JSON.parse result) or {})

set-in-redis = !(sid, session, fn)->
  redis-store.set sid, (JSON.stringify session), !(err, result)->
    if err then fn(err) else fn(session)

restore-in-redis = !(new-sid, old-sid, fn)->
  redis-store.get old-sid, (err, result)->
    if err
      fn(err)
    else 
      old-session = JSON.parse(result) or {}
      old-session.sid = new-sid
      redis-store.set new-sid, (JSON.stringify old-session), !(err, result)->
        redis-store.del old-sid
        if err then fn(err) else fn(old-session)

module.exports =

  get: ->
    if type is 'redis'
      get-in-redis.apply null, arguments
    else
      get-in-memory.apply null, arguments
  set: ->
    if type is 'redis'
      set-in-redis.apply null, arguments
    else
      set-in-memory.apply null, arguments
  
  restore: ->
    if type is 'redis'
      restore-in-redis.apply null, arguments
    else
      restore-in-memory.apply null, arguments
  
  config: !(cfg)->
    type := cfg.type
    redis-store := redis.create-client() if not redis-store and type is 'redis'


