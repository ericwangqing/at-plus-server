location =
  _id: 'xxxx'
  type: 'real' # real | web
  name: '中山大学体育馆'
  is-exist: true # default
  is-private: false # default
  owners: ['uid-1', 'cid-1'] # only available when is-private is true
  url: void # only available when the type is web
  # the following properties only available when the type is real
  alias: ['中大体育馆', '东校区体育馆']
  center-point: # 该location涵盖范围的中心点
    longitude: '123'
    altitude: '123'
    latitude: '123'
  radius: '123' # 涵盖半径 (米)
  address: "中国|广东省|广州市|大学城（510006）|中山大学|体育馆"
