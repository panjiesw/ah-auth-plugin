###
#Grunt Tasks
*__Author__: Panjie SW <panjie@panjiesw.com>*
*__Project__: ah-nodemailer-plugin*
*__Company__: PanjieSW*

Defines tasks for Grunt
*********************************************
###

module.exports = (grunt) ->
  ###
  Constants
  ###
  SRC = ".src"

  ACTION = "actions"
  CONFIG = "config"
  INITIALIZER = "initializers"
  TASK = "tasks"
  MAIL = "templates"

  ###
  Tasks Definitions
  ###
  tasks = {}

  ###
  Coffee Tasks.
  Compile coffee script for API Server
  ###
  tasks.coffee =
    dev:
      files: [
        {
          expand: yes
          cwd: "#{SRC}"
          src: [
            "#{ACTION}/**/*.coffee"
            "#{CONFIG}/**/*.coffee"
            "#{INITIALIZER}/**/*.coffee"
            "#{TASK}/**/*.coffee"
            "*.coffee"
          ]
          dest: "./"
          ext: '.js'
        }
      ]

  ###
  Watch Tasks.
  Watch files for change and the run specific task.
  ###
  tasks.watch =
    coffee:
      files: [
        "#{SRC}/#{ACTION}/**/*.coffee"
        "#{SRC}/#{CONFIG}/**/*.coffee"
        "#{SRC}/#{INITIALIZER}/**/*.coffee"
        "#{SRC}/#{TASK}/**/*.coffee"
        "#{SRC}/*.coffee"
      ]
      tasks: "newer:coffee:dev"

  tasks.clean = ["#{ACTION}", "#{CONFIG}", "#{INITIALIZER}", "#{TASK}"]

  grunt.initConfig tasks

  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-newer'

  grunt.registerTask "dev", [
    "coffee:dev"
  ]

  grunt.registerTask "default", [
    "dev"
    "watch"
  ]
