require! [async, '../bin/config', '../bin/channel-initial-wrapper']
debug = require('debug')('at-plus')
_ = require 'underscore'
io = require 'socket.io-client'

#------------------- Utility Classes ------------------#

class Sockets-distroyer # Singleton
  instance = null

  class Destroyer
    !->
      @client-sockets = []
    add-socket: !(socket)->
      @client-sockets.push socket
    destroy-all: !->
      debug "destroyer sockets: ", [socket.socket.sessionid for socket in @client-sockets ]
      for socket in @client-sockets
        socket = socket.socket if socket.socket # 当socket.io 连接到有namespace的情况要用socket.socket.disconnect!
        socket.disconnect!
      @client-sockets = []

  @get = (socket)->
    instance ?:= new Destroyer socket


#------------------- Utility Functions ------------------#

clear-all-client-sockets = !->
  delete (require 'socket.io-client/lib/io.js').sockets[config.server.base-url]

initial-client = !(channels-configs, callback)->
  channels = {}
  clear-all-client-sockets!
  async.each-series (_.keys SERVER_CHANNELS), (channel, next)->
    if channels-configs[channel] # 需要初始化该频道
      channel-config = channels-configs[channel] <<< {url: SERVER_CHANNELS[channel]}
      (socket, data) <-! initial-channel channel-config
      channels[channel] = socket
      next!
    else
      next!
  , !->
    callback channels


initial-channel = !(channel-config, callback)->
  (socket, data) <-! request-server {url: channel-config.url} <<< channel-config.options
  debug "initial-channel, socket: ", socket.socket.sessionid
  default-channel = socket
  channel-config.business-handler-register socket, data if channel-config.business-handler-register
  callback socket, data

request-server = !(alter-option, business-handlers-register) ->
  channel-initial-wrapper.client-channel-initial-wrapper {
    io: io
    url: base-url
    options: options
    business-handlers-register: !(client, response-initial-data, initial-callback)->
      business-handlers-register client, response-initial-data
      initial-callback!
  } <<< alter-option

base-url = config.server.base-url
default-channel-url = base-url
testing-helper-channel-url = base-url + "/testing-helper"
users-channel-url = base-url + "/users"
locations-channel-url = base-url + "/locations"
interesting-points-channel-url = base-url + "/interesting-points"
chats-channel-url = base-url + "/chats"

options = 
  # transports: ['websocket']
  'force new connection': false
  'reconnect': false

SERVER_CHANNELS =
  default-channel: default-channel-url
  testing-helper-channel: testing-helper-channel-url
  users-channel: users-channel-url
  locations-channel: locations-channel-url
  interesting-points-channel: interesting-points-channel-url
  chats-channel: chats-channel-url


module.exports =
  Sockets-distroyer: Sockets-distroyer
  clear-all-client-sockets: clear-all-client-sockets
  initial-client: initial-client
