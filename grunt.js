module.exports = function(grunt) {

  grunt.loadNpmTasks("grunt-clean")
  grunt.loadNpmTasks("grunt-contrib-copy")
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks("grunt-contrib-handlebars")

  grunt.initConfig({
    clean: {
      all: "client/www"
    },
    copy: {
      all: {
        files: {
          "client/www/": "client/assets/**"
        }
      }
    },
    coffee: {
      shared: {
        files: {
          "client/www/*.js": "shared/!(templates)/*"
        }
      },
      client: {
        files: {
          "client/www/*.js": "client/coffee/**"
        }
      }
    },
    handlebars: {
      all: {
        options: {
          namespace: "App.templates",
          processName: function(filename) {
            return filename.replace("shared/templates/", "").replace(".htm", "")
          }
        },
        files: {
          "client/www/app/templates.js": "shared/templates/**"
        }
      }
    }
  })

  grunt.registerTask("default", "clean copy coffee handlebars")

}
