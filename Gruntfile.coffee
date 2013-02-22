module.exports = (grunt) ->
  grunt.initConfig

    dir:
      build: "client/build"
      prod: "client/www"
      assets: "client/assets"
      shared: "shared"
      code: "client/coffee"
      styles: "client/stylus"

    clean:
      build: "<%= dir.build %>"
      prod: "<%= dir.prod %>"

    copy:
      all:
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
          dest: "<%= dir.build %>"
          ext: ".js"
        ]

      client:
        files: [
          expand: yes
          cwd: "<%= dir.code %>"
          src: "**/*.coffee"
          dest: "<%= dir.build %>"
          ext: ".js"
        ]

    handlebars:
      all:
        options:
          namespace: no
          amd: yes
          processName: (filename) ->
            filename.replace("shared/templates/", "").replace(".htm", "")
        files: [
          expand: yes
          cwd: "<%= dir.shared %>/templates/"
          src: "**/*.htm"
          dest: "<%= dir.build %>/templates"
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

    requirejs:
      compile:
        options:
          baseUrl: "<%= dir.build %>"
          mainConfigFile: "<%= dir.build %>/common.js"
          optimizeCss: "standard"
          dir: "<%= dir.prod %>"
          name: "common"

  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-handlebars"
  grunt.loadNpmTasks "grunt-contrib-watch"
  grunt.loadNpmTasks "grunt-contrib-requirejs"

  grunt.registerTask "build", ["clean:build", "copy", "coffee", "handlebars"]
  grunt.registerTask "dev", ["build", "watch"]
  grunt.registerTask "prod", ["build", "clean:prod", "requirejs"]
  grunt.registerTask "default", ["prod"]
