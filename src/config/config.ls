/*
 * Created by Wang, Qing. All rights reserved.
 */

module.exports <<< 
  server:
    port: 3000
  mongo:
    host: \localhost
    port: 27017
    db: \at-plus-test
    collections: ['interesting-points', 'locations'] 
  session-store:
    type: 'redis' # in-memory | redis 
    # type: 'in-momery' # in-memory | redis
