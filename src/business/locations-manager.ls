'''
FAKE 假实现，需要更换成为真正的实现。
'''
require! '../test-bin/utils'
debug = require('debug')('at-plus')

resolve-locations = !(request-locations, callback)->
  sysu-location = utils.load-fixture 'sysu-location'
  youku-location = utils.load-fixture 'youku-location'
  callback [sysu-location, youku-location]

module.exports =
  resolve-locations: resolve-locations
