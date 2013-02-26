module.exports = (grunt) ->
  grunt.initConfig

    dir:
      shared:
        root: "shared"
        templates: "shared/templates"
      client:
        assets: "client/assets"
        code: "client/coffee"
        widgets: "client/widgets"
        styles: "client/stylus"
      build:
        root: "client/build"
        css: "client/build/css"
        js: "client/build/js"
        templates: "client/build/js/templates"
        widgets: "client/build/js/widgets"
      prod:
        root: "client/www"
        css: "client/www/css"
        js: "client/www/js"
        widgets: "client/www/js/widgets"

    clean:
      build: "<%= dir.build.root %>"
      prod: "<%= dir.prod.root %>"
      widgets: "<%= dir.prod.widgets %>/*/*"

    copy:
      assets:
        files: [
          expand: yes
          cwd: "<%= dir.client.assets %>"
          src: "**"
          dest: "<%= dir.build.root %>"
        ]

    coffee:
      shared:
        files: [
          expand: yes
          cwd: "<%= dir.shared.root %>"
          src: "**/*.coffee"
          dest: "<%= dir.build.js %>"
          ext: ".js"
        ]
      client:
        files: [
          expand: yes
          cwd: "<%= dir.client.code %>"
          src: "**/*.coffee"
          dest: "<%= dir.build.js %>"
          ext: ".js"
        ]
      widgets:
        files: [
          expand: yes
          cwd: "<%= dir.client.widgets %>"
          src: "**/*.coffee"
          dest: "<%= dir.build.widgets %>"
          ext: ".js"
        ]

    handlebars:
      shared:
        options:
          namespace: no
          amd: yes
        files: [
          expand: yes
          cwd: "<%= dir.shared.templates %>"
          src: "**/*.htm"
          dest: "<%= dir.build.templates %>"
          ext: ".js"
        ]
      widgets:
        options:
          namespace: no
          amd: yes
        files: [
          expand: yes
          cwd: "<%= dir.client.widgets %>"
          src: "*/templates/*.htm"
          dest: "<%= dir.build.widgets %>"
          ext: ".js"
        ]

    watch:
      shared_code:
        files: "<%= dir.shared.root %>/**/*.coffee"
        tasks: "coffee:shared"
      client_code:
        files: "<%= dir.client.code %>/**/*.coffee"
        tasks: "coffee:client"
      widgets_code:
        files: "<%= dir.client.widgets %>/**/*.coffee"
        tasks: "coffee:widgets"
      shared_templates:
        files: "<%= dir.shared.templates %>/**/*.htm"
        tasks: "handlebars:shared"
      widgets_templates:
        files: "<%= dir.client.widgets %>/*/templates/*.htm"
        tasks: "handlebars:widgets"
      styles:
        files: "<%= dir.client.styles %>/**/*.styl"
        tasks: "stylus"

    cssmin:
      bootstrap:
        files:
          "<%= dir.prod.css %>/bootstrap.css": "<%= dir.build.css %>/bootstrap.css"

    requirejs:
      compile:
        options:
          baseUrl: "<%= dir.build.js %>"
          mainConfigFile: "<%= dir.build.js %>/config.js"
          dir: "<%= dir.prod.js %>"
          modules: [
            {
              name: "app"
            }
            {
              name: "widgets/hello"
              exclude: ["app"]
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
