# -------------------- Web locations --------------
locations =
  * _id: 'xxxx'
    type: 'web'
    name: '中山大学体育馆主页'
    is-existing: true
    is-internal: false # default 为true时，指不能够从公网访问的网页，或者公众无法进入的现实区域
    alias: ['中大体育馆主页']
    url: 'http://sysu.edu.cn/gym'  
    interesting-points: [...] # TODO：待细化  
    subsitute-to-locations:
      * _id: 'xxxx'
        type: 'web'
        name: '中山大学体育馆主页'
        is-existing: false
        is-internal: false # default 为true时，指不能够从公网访问的网页，或者公众无法进入的现实区域
        alias: ['中大体育馆旧主页']
        url: 'http://sysu.edu.cn/gym'    
        interesting-points: [...] # TODO：待细化  
        web-page-snapshot: 'http://at-plus-server/web-page-snapshot/_id'
      ...
  ...    

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

