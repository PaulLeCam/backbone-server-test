module.exports = (grunt) ->
  grunt.initConfig

    dir:
      build: "client/build"
      buildjs: "client/build/js"
      prod: "client/www"
      assets: "client/assets"
      shared: "shared"
      code: "client/coffee"
      widgets: "client/widgets"
      styles: "client/stylus"

    clean:
      build: "<%= dir.build %>"
      prod: "<%= dir.prod %>"
      widgets: "<%= dir.prod %>/js/widgets/*/*"

    copy:
      assets:
        files: [
          expand: yes
          cwd: "<%= dir.assets %>"
          src: "**"
          dest: "<%= dir.build %>"
        ]

    coffee:
      shared:
        files: [
          expand: yes
          cwd: "<%= dir.shared %>"
          src: "**/*.coffee"
          dest: "<%= dir.buildjs %>"
          ext: ".js"
        ]
      client:
        files: [
          expand: yes
          cwd: "<%= dir.code %>"
          src: "**/*.coffee"
          dest: "<%= dir.buildjs %>"
          ext: ".js"
        ]
      widgets:
        files: [
          expand: yes
          cwd: "<%= dir.widgets %>"
          src: "**/*.coffee"
          dest: "<%= dir.buildjs %>/widgets"
          ext: ".js"
        ]

    handlebars:
      shared:
        options:
          namespace: no
          amd: yes
        files: [
          expand: yes
          cwd: "<%= dir.shared %>/templates/"
          src: "**/*.htm"
          dest: "<%= dir.buildjs %>/templates"
          ext: ".js"
        ]
      widgets:
        options:
          namespace: no
          amd: yes
        files: [
          expand: yes
          cwd: "<%= dir.widgets %>"
          src: "*/templates/*.htm"
          dest: "<%= dir.buildjs %>/widgets"
          ext: ".js"
        ]

    watch:
      coffee:
        files: ["<%= dir.shared %>/**/*.coffee", "<%= dir.code %>/**/*.coffee"]
        tasks: "coffee"
      handlebars:
        files: "<%= dir.shared %>/templates/**/*.htm"
        tasks: "handlebars"
      stylus:
        files: "<%= dir.styles %>/**/*.styl"
        tasks: "stylus"

    cssmin:
      bootstrap:
        files:
          "<%= dir.prod %>/css/bootstrap.css": "<%= dir.build %>/css/bootstrap.css"

    requirejs:
      compile:
        options:
          baseUrl: "<%= dir.buildjs %>"
          mainConfigFile: "<%= dir.buildjs %>/common.js"
          dir: "<%= dir.prod %>/js"
          modules: [
            {
              name: "common"
            }
            {
              name: "widgets/hello"
              exclude: ["common"]
            }
          ]

  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-handlebars"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-cssmin"
  grunt.loadNpmTasks "grunt-contrib-requirejs"

  grunt.registerTask "build", ["clean:build", "copy:assets", "coffee", "handlebars"]
  grunt.registerTask "dev", ["build", "watch"]
  grunt.registerTask "prod", ["build", "clean:prod", "cssmin", "requirejs", "clean:widgets"]
  grunt.registerTask "default", ["prod"]
