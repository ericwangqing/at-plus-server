module.exports = (grunt)->
  grunt.initConfig
    clean: ["bin"]
    copy:
      main:
        files: [{expand: true, cwd:'resource/', src: ['**'], dest: 'bin/'}]
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
          cwd: 'test'
          src: ['**/*.ls']
          dest: 'test-bin/'
          ext: '.spec.js'
        ]
    jshint:
      files: "bin/**/*.js"
    simplemocha:
      src: 'test-bin/**/*.spec.js'
      options:
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
        tasks: ["livescript:test", "simplemocha"]
      # test_run:
      #   files: ["bin/**/*.js", "test-bin/**/*.spec.js"]
      #   tasks: ["simplemocha"]
    nodemon:
      all:
        options: 
          watchedFolders: ['bin']
          # delayTime: 1
          # env:
          #   PORT: '9999'
    concurrent:
      target: 
        tasks:
          ['watch', 'nodemon']
        options:
          logConcurrentOutput: true
        # tasks: ['nodemon', 'watch']

  grunt.loadNpmTasks "grunt-livescript"
  grunt.loadNpmTasks "grunt-simple-mocha"
  grunt.loadNpmTasks "grunt-nodemon"
  grunt.loadNpmTasks "grunt-concurrent"
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"

  grunt.registerTask "default", ["clean", "copy", "livescript", "concurrent:target"]

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

