require 'should'

can = it # it在LiveScript中被作为缺省的参数，因此我们先置换为can

describe '测试grunt-simple-mocha', !->
  can '成功输出', !(done)->
    [1,2].length.should.eql 2  
    done!