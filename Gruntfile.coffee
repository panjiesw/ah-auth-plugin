module.exports = (grunt) ->
  grunt.initConfig
    jade:
      dev:
        options:
          pretty: yes
          data: (dest, src) ->
            'DEV': yes
        files: [
          {
            expand: yes
            cwd: ".src/jade"
            src: ["**/*.jade"]
            dest: "."
            ext: ".html"
          }
        ]
      dist:
        files: [
          {
            expand: yes
            cwd: ".src/jade"
            src: ["**/*.jade"]
            dest: "."
            ext: ".html"
          }
        ]

    less:
      dev:
        options:
          paths: [
            './bower_components'
            './.src/less'
          ]
        files:
          'css/app.css': '.src/less/app.less'
          'css/app-theme.css': '.src/less/app-theme.less'
      dist:
        options:
          paths: [
            './bower_components'
            './less'
          ]
          cleancss: yes
          # sourceMap: yes
          # outputSourceFiles: yes
          # sourceMapFilename: 'css/app.css.map'
        files:
          'css/app.min.css': '.src/less/app.less'
          'css/app-theme.min.css': '.src/less/app-theme.less'

    copy:
      dev:
        files: [
          # Jquery
          {
            cwd: "bower_components/jquery/dist"
            src: "jquery*"
            dest: "scripts/"
            expand: yes
          }
          # Bootstrap
          {
            cwd: "bower_components/bootstrap/dist/js"
            src: "bootstrap*"
            dest: "scripts/"
            expand: yes
          }
          {
            cwd: "bower_components/jasny-bootstrap/dist/js"
            src: "jasny-bootstrap*"
            dest: "scripts/"
            expand: yes
          }
          {
            cwd: "bower_components/jasny-bootstrap/dist/css"
            src: "jasny-bootstrap*"
            dest: "css/"
            expand: yes
          }
          # GlyphIcons
          {
            cwd: "bower_components/bootstrap/dist/fonts"
            src: "**"
            dest: "fonts"
            expand: yes
          }
        ]

    jekyll:
      options:
        src: '.'
      dev:
        options:
          dest: '_build'
      dist:
        options:
          dest: '_site'

    watch:
      jade:
        files: ['.src/jade/**/*.jade']
        tasks: 'jade:dev'
      less:
        files: ['.src/less/**/*.less']
        tasks: 'less:dev'
      jekyll:
        files: [
          '**/*.html'
          '**/*.md'
          'img/**'
          'css/**/*.css'
          '!_site/**/*'
          '!_build/**/*'
        ]
        tasks: 'jekyll:dev'
        options:
          livereload: yes

    clean: [
      'css/*.css'
      'css/*.map'
      'scripts/*.js'
      'scripts/*.map'
      'fonts/**'
      '_build/**'
    ]

    connect:
      server:
        options:
          port: 4000
          base: '_build'

  grunt.loadNpmTasks 'grunt-contrib-jade'
  grunt.loadNpmTasks 'grunt-contrib-less'
  grunt.loadNpmTasks 'grunt-contrib-watch'
  grunt.loadNpmTasks 'grunt-contrib-copy'
  grunt.loadNpmTasks 'grunt-contrib-clean'
  grunt.loadNpmTasks 'grunt-contrib-connect'
  grunt.loadNpmTasks 'grunt-jekyll'

  grunt.registerTask 'dev', [
    'less:dev'
    'jade:dev'
    'copy:dev'
    'jekyll:dev'
  ]

  grunt.registerTask 'dist', [
    'clean'
    'less:dist'
    'jade:dist'
    'jekyll:dist'
  ]

  grunt.registerTask 'default', [
    'dev'
    'connect'
    'watch'
  ]
