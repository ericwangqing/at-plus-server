module.exports = (grunt)->
  grunt.initConfig
    clean: ["bin"]
    copy:
      main:
        files: [{expand: true, cwd:'resource/', src: ['**'], dest: 'bin/'}]
    livescript:
      dynamic_mappings:
        files: [
          expand: true
          flatten: true
          cwd: 'src'
          src: ['**/*.ls']
          dest: 'bin/'
          ext: '.js'
        ]
    jshint:
      files: "bin/**/*.js"
    watch:
      all:
        files: ["src/**/*.ls"]
        tasks: ["copy", "livescript"]
        options:
          livereload: true
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
  grunt.loadNpmTasks "grunt-nodemon"
  grunt.loadNpmTasks "grunt-concurrent"
  grunt.loadNpmTasks "grunt-contrib-jshint"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"

  grunt.registerTask "default", ["clean", "copy", "livescript", "concurrent:target"]
