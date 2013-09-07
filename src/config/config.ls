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
    # session-store-type: 'redis' # in-memory | redis 
    session-store-type: 'in-momery' # in-memory | redis
