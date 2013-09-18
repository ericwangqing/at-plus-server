locations = 
  sysu-locaiton =
    _id: "lid-1" # 在load到mongodDB后，自动生成
    type: "web"
    name: "中山大学软件学院"
    is-existing: true
    is-internal: false # default 为true时，指不能够从公网访问的网页，或者公众无法进入的现实区域
    duration: 
      from: '2013-02-04 12:00:04'
      to: '2014-02-04 12:00:04' # 第一次报告这个location时from与to相同，之后，to是最后一次报告的时间
    alias: ["软件学院主页", "软院主页"]
    urls: ["http://ss.sysu.edu.cn/InformationSystem/", "http://ss.sysu.edu.cn/"]
    retrieved-html: '<html> ... </html>'
    web-page-snapshot: '/web-page-snapshot/lid-1' # 网页的快照，用于定位兴趣点（现在未必有用，但是将来会有用）
  
  youku-location = 
    _id: "lid-2" # 今后将由@+（mongoDB）自动生成
    type: "web"
    name: "【全场集锦】-于大宝郑龙2球张稀哲传射 国足6-1践行誓言—在线播放—优酷网，视频高清在线观看"
    duration: 
      from: '2013-02-04 12:00:04'
      to: '2014-02-04 12:00:04' # 第一次报告这个location时from与to相同，之后，to是最后一次报告的时间
    is-existing: true
    is-internal: false # default 为true时，指不能够从公网访问的网页，或者公众无法进入的现实区域
    urls: ["http://v.youku.com/v_show/id_XNjA1OTQ2OTI0.html"]
    retrieved-html: '<html> ... </html>'
    web-page-snapshot: '/web-page-snapshot/lid-2' # 网页的快照，用于定位兴趣点（现在未必有用，但是将来会有用）

  OTHER_ONE_NOT_FOUND_IN_TEST =
    _id: "lid-x" # 今后将由@+（mongoDB）自动生成
    type: "web"
    name: "xxx"
    duration: 
      from: '2013-02-04 12:00:04'
      to: '2014-02-04 12:00:04' # 第一次报告这个location时from与to相同，之后，to是最后一次报告的时间
    is-existing: true
    is-internal: false # default 为true时，指不能够从公网访问的网页，或者公众无法进入的现实区域
    urls: ["xxx"]
    retrieved-html: '<html> ... </html>'
    web-page-snapshot: 'xxx' # 网页的快照，用于定位兴趣点（现在未必有用，但是将来会有用）

