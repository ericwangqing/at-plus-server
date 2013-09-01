module.exports = (grunt)->
  grunt.initConfig
    clean: ["bin", 'test-temp', 'test-bin']
    copy:
      main:
        files: [{expand: true, cwd:'resource/', src: ['**'], dest: 'bin/'}]
    concat: # 将每个测试中都要用的部分抽出来
      prefix_test:
        options:
          banner: '''
io = require 'socket.io-client'
# patch = require './patch-io-client-with-session'
require! {should, async, _: underscore}

base-url = 'http://localhost:3000'
options = 
  transports: ['websocket']
  'force new connection': true

can = it # it在LiveScript中被作为缺省的参数，因此我们先置换为can

          '''
        files: [
          expand: true # 将来改为在dev下的配置
          # flatten: true
          cwd: 'test'
          src: ['**/*.ls', '!**/*patch*', '!**/*helper*']
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
        files: [
          expand: true
          flatten: true
          cwd: 'test'
          src: ['**/*patch*.ls', '**/*helper*.ls']
          dest: 'test-bin/'
          ext: '.js'
        ]
    jshint:
      files: "bin/**/*.js"
    simplemocha:
      src: 'test-bin/**/*.spec.js'
      options:
        # require: 'should' # use should in tests without requiring in each
        reporter: 'spec'
        slow: 200
        timeout: 1000
    watch:
      src:
        files: ["src/**/*.ls"]
        tasks: ["copy", "livescript:src",  "delayed-simplemocha"]
        options:
          livereload: true
      test_compile:
        files: ["test/**/*.ls"]
        tasks: ["concat", "livescript:test", "livescript:test_helper", "simplemocha"]
    nodemon:
      all:
        options: 
          watchedFolders: ['bin']
    concurrent:
      target: 
        tasks:
          ['watch', 'nodemon']
        options:
          logConcurrentOutput: true

  grunt.loadNpmTasks "grunt-livescript"
  grunt.loadNpmTasks "grunt-simple-mocha"
  grunt.loadNpmTasks "grunt-nodemon"
  grunt.loadNpmTasks "grunt-concurrent"
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-concat"

  grunt.registerTask "default", ["clean", "copy", "concat", "livescript", "concurrent:target"]
  grunt.registerTask "test", ["simplemocha"]


  grunt.registerTask 'delayed-simplemocha', "run mocha 1000ms later", ->
    done = this.async()
    DELAY = 2000
    grunt.log.writeln 'run mocha after %dms', DELAY
    setTimeout (->
      grunt.task.run 'simplemocha'
      done()
    ), DELAY

  grunt.event.on 'watch', (action, filepath)->
    console.log 'filepath: ', filepath
    grunt.config ['livescript', 'src'], filepath
    grunt.config ['livescript', 'test'], filepath

