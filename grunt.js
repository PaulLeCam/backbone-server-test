module.exports = function(grunt) {

  grunt.loadNpmTasks("grunt-clean")
  grunt.loadNpmTasks("grunt-contrib-copy")
  grunt.loadNpmTasks("grunt-contrib-coffee")
  grunt.loadNpmTasks("grunt-contrib-handlebars")
  grunt.loadNpmTasks("grunt-contrib-requirejs")

  grunt.initConfig({
    clean: {
      all: ["client/build", "client/www"]
    },
    copy: {
      all: {
        files: {
          "client/build/": "client/assets/**"
        }
      }
    },
    coffee: {
      shared: {
        files: {
          "client/build/*.js": "shared/!(templates)/*"
        }
      },
      client: {
        files: {
          "client/build/*.js": "client/coffee/**"
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
          "client/build/app/templates.js": "shared/templates/**"
        }
      }
    },
    requirejs: {
      compile: {
        options: {
          baseUrl: "client/build",
          mainConfigFile: "client/build/common.js",
          optimizeCss: "standard",
          dir: "client/www",
          name: "common"
        }
      }
    }
  })

  grunt.registerTask("default", "clean copy coffee handlebars requirejs")

}
