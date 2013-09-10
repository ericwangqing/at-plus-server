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
    write-concern: -1 # 'majority' , MongoDB在write concern上又变化，这里需要进一步查清如何应对。-1就是以前的safe。
    collections: ['interesting-points', 'locations'] 
  session-store:
    # type: 'redis' # in-memory | redis 
    type: 'in-momery' # in-memory | redis
