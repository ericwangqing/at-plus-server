# -------------------- Web locations --------------
location =
  _id: "lid-1"
  type: "web"
  name: "中山大学软件学院"
  isExisting: true
  isInternal: false
  alias: ["软件学院主页", "软院主页"]
  urls: ["http://ss.sysu.edu.cn/InformationSystem/", "http://ss.sysu.edu.cn/"]
  webPageSnapshot: "/web-page-snapshot/lid-1"
  interestingPointsSummaries: [
    _id: "ipid-1"
    title: "无法阻挡的@+"
    content: "人类已经无法阻挡@+了"
    createTime: "2013-08-18 23:11:09"
    createdBy:
      _id: "uid-1"
      isCurrentUser: true

    isPrivate: false
    commentedBy: [
      _id: "uid-2"
      name: "柏信"
      avatar: "/avatars/u/uid-2/1"
      isMyFriend: true
    ,
      _id: "uid-4"
      name: "User 4"
      avatar: "/avatars/s/1"
    ,
      _id: "uid-8"
      name: "User 8"
      avatar: "/avatars/s/1"
    ]
    sharedWith: [
      _id: "uid-2"
      name: "柏信"
      avatar: "/avatars/u/uid-2/1"
      isMyFriend: true
    ]
    watchedBy: [
      _id: "uid-4"
      name: "User 4"
      avatar: "/avatars/s/1"
    ,
      _id: "uid-5"
      name: "User 5"
      avatar: "/avatars/s/1"
      isFollowedByMe: true
    ]
    pictures: [
      type: "snapshoot"
      url: "/user-pictures/uid-1/1"
      createTime: "2013-02-04 12:00:04"
    ]
    reposts: [
      type: "weibo"
      repostId: "weibo-1"
      url: "http://weibo.com/1"
    ]
    tags: ["tid-1", "tid-2"]
    positionWithinWebPage:
      relatedTextContent: "人们可以在任何网页上自由评论，吐槽"
      relatedImage: "http://some.com/images/1.jpg"
      pinPointDom: ".content div span 0"
      offset:
        x: "10em"
        y: "15em"

      size:
        width: "20em"
        height: "20em"

    recentMessages: [
      createTime: "2013-02-04 12:23:02"
      sendBy: "uid-2"
      permlink: "http://at-plus.com/messages/mid-3"
      textContent: "快乐无极限+2"
    ,
      createTime: "2013-02-04 12:13:02"
      sendBy: "uid-4"
      permlink: "http://at-plus.com/messages/mid-2"
      textContent: "快乐无极限+1"
    ]
  ]

# -------------------- real locations --------------
location =
  _id: 'xxx'
  type: 'real'
  name: '中山大学东校区'
  is-existing: true
  is-internal: false
  alias: ['中大东校区']
  center-point:
    longitude: '232'
    latitude: '212'
    altitude: '11'
  radius: '1234'
  latitude-scope: '52'
  address: '中国 | 广东省 | 广州市 | 大学城（510006）| 中山大学'
  interesting-points: [...] # TODO：待细化  
  subsitute-to-locations:
    * _id: 'xxx'
      type: 'real'
      name: '中山大学体育馆'
      is-existing: true
      is-internal: false
      alias: ['中大体育馆', '东校区体育馆']
      center-point:
        longitude: '222'
        latitude: '222'
        altitude: '11'
      radius: '123'
      latitude-scope: '22'
      address: '中国 | 广东省 | 广州市 | 大学城（510006）| 中山大学 | 体育馆'
      interesting-points: [...] # TODO：待细化  
    ...

