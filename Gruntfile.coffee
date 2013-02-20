module.exports = (grunt) ->
  grunt.initConfig

    clean:
      all: ["client/build", "client/www"]

    copy:
      all:
        files: [
          expand: yes
          cwd: "client/assets/"
          src: "**"
          dest: "client/build/"
        ]

    coffee:
      shared:
        files: [
          expand: yes
          cwd: "shared/"
          src: "**/*.coffee"
          dest: "client/build/"
          ext: ".js"
        ]

      client:
        files: [
          expand: yes
          cwd: "client/coffee/"
          src: "**/*.coffee"
          dest: "client/build/"
          ext: ".js"
        ]

    handlebars:
      all:
        options:
          namespace: "App.templates"
          amd: yes
          processName: (filename) ->
            filename.replace("shared/templates/", "").replace(".htm", "")
        files: [
          src: "shared/templates/**/*.htm"
          dest: "client/build/app/templates.js"
        ]

    requirejs:
      compile:
        options:
          baseUrl: "client/build"
          mainConfigFile: "client/build/common.js"
          optimizeCss: "standard"
          dir: "client/www"
          name: "common"

  grunt.loadNpmTasks "grunt-contrib-clean"
  grunt.loadNpmTasks "grunt-contrib-copy"
  grunt.loadNpmTasks "grunt-contrib-coffee"
  grunt.loadNpmTasks "grunt-contrib-handlebars"
  grunt.loadNpmTasks "grunt-contrib-requirejs"

  grunt.registerTask "default", ["clean", "copy", "coffee", "handlebars", "requirejs"]
