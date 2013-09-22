location =
  _id: 'xxxx'
  type: 'real' # real | web
  name: '中山大学体育馆'
  is-existing: true # default
  is-internal: false # default 为true时，指不能够从公网访问的网页，或者公众无法进入的现实区域
  duration: 
    from: '2014-02-04 12:00:04'
    to: '2014-02-04 12:00:04' # 第一次报告这个location时from与to相同，之后，to是最后一次报告的时间
  is-internal: false # default 不能够从公网被访问的内网网页，需要permission才能够进入的区域
  urls: [] # url, only available when the type is web, 同一网页可能有多个网址对应。今后这部分可能单独做出一个key-value的应用来进行甑别。
  retrieved-html: '<html> ... </html>'
  web-page-snapshot: '/web-page-snapshot/_id' # 网页的快照，用于定位兴趣点（现在未必有用，但是将来会有用）
  # the following properties only available when the type is real
  alias: ['中大体育馆', '东校区体育馆']
  center-point: # 该location涵盖范围的中心点
    longitude: '123'
    latitude: '123'
    altitude: '123'
  radius: '123' # 涵盖半径 (米)
  altitude-scope：'123' # 海拔以中心点开始的范围（米）
  address: "中国|广东省|广州市|大学城（510006）|中山大学|体育馆"
  subsituted-location: "lid-2" # 当前location已经不存在时，此location替代当前locaiton来容纳兴趣点。此时，这些兴趣点作为依附兴趣点显示。
