# ！！注意，在开发时，请注意观察控制台的输出，关注server restart的时机，如果在simplemocha之前，一切OK。
# 否则，在simplemocha之后，才restart server，测试的结果将不是最新更改的情况。遇到这种状况，再次保存一下src
# 触发grunt，看看是否能够顺序正常。
# 原因：watch和nodemon分别定时扫描文件，因此二者可能一个早发现、一个晚发现，再加上二者的扫描间隔也有不同，
# 就会导致触发complie和server restart的时间、次序随机不同。
# 终极策略：将下面的TIME_WAIT_SERVER_RESTART调整到足够大。
TIME_WAIT_SERVER_RESTART = 1000 # BE CAREFUL! May need more time for lower computers. !!
module.exports = (grunt)->
  grunt.initConfig
    clean: ["bin", 'test-temp', 'test-bin']
    copy:
      main:
        files: [{expand: true, cwd:'resource/', src: ['**'], dest: 'bin/'}]
    concat: # 将每个测试中都要用的部分抽出来
      prefix_test:
        options:
          banner: require('fs').readFileSync('test/header.ls', {encoding: 'utf-8'})
        files: [
          expand: true # 将来改为在dev下的配置
          # flatten: true
          cwd: 'test'
          src: ['**/*.ls', '!header.ls', '!helpers/*', '!fixtures/*']
          dest: 'test-temp/'
          ext: '.ls'
        ]
    livescript:
      src:
        files: [
          expand: true
          flatten: true
          cwd: 'src'
          src: ['**/*.ls']
          dest: 'bin/'
          ext: '.js'
        ]
      test:
        files: [
          expand: true # 将来改为在dev下的配置
          flatten: true
          cwd: 'test-temp'
          src: ['**/*.ls']
          dest: 'test-bin/'
          ext: '.spec.js'
        ]
      test_helper:
        options:
          bare: true
        files: [
          expand: true
          flatten: true
          cwd: 'test'
          src: ['helpers/*.ls', 'fixtures/*.ls']
          dest: 'test-bin/'
          ext: '.js'
        ]
    jshint:
      files: "bin/**/*.js"
    env:
      test:
        DEBUG: "at-plus"
    simplemocha:
      src: 'test-bin/**/*.spec.js'
      options:
        # require: 'should' # use should in tests without requiring in each
        reporter: 'spec'
        slow: 100
        timeout: 3000
    watch:
      src:
        files: ["src/**/*.ls"]
        tasks: ["copy", "livescript:src",  "delayed-simplemocha"]
        options:
          spawn: true
      test_compile:
        files: ["test/**/*.ls"]
        tasks: ["concat", "livescript:test", "livescript:test_helper", "env:test", "simplemocha"]
    nodemon:
      all:
        options: 
          file: 'bin/app.js'
          watchedFolders: ['bin']
          env:
            DEBUG: 'at-plus'
    concurrent:
      target: 
        tasks:
          ['nodemon', 'watch']
        options:
          logConcurrentOutput: true

  grunt.loadNpmTasks "grunt-livescript"
  grunt.loadNpmTasks "grunt-simple-mocha"
  grunt.loadNpmTasks "grunt-nodemon"
  grunt.loadNpmTasks "grunt-env"
  grunt.loadNpmTasks "grunt-concurrent"
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-concat"

  grunt.registerTask "default", ["clean", "copy", "concat", "livescript", "concurrent"]
  grunt.registerTask "test", ["env:test", "simplemocha"]


  grunt.registerTask 'delayed-simplemocha', "run mocha later for nodemon picks up changes", ->
    done = this.async()
    DELAY = TIME_WAIT_SERVER_RESTART 
    grunt.log.writeln 'run mocha after %dms', DELAY
    setTimeout (->
      grunt.task.run 'simplemocha'
      done()
    ), DELAY

  grunt.event.on 'watch', (action, filepath)->
    console.log 'filepath: ', filepath
    grunt.config ['livescript', 'src'], filepath
    grunt.config ['livescript', 'test'], filepath

