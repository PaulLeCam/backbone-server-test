require.config

  baseUrl: "/"

  deps: ["app"]

  shim:
    backbone:
      deps: ["underscore", "jquery"]
      exports: "Backbone"
    handlebars:
      exports: "Handlebars"

  paths:
    jquery: "libs/jquery"
    underscore: "libs/lodash"
    handlebars: "libs/handlebars.runtime"
    backbone: "libs/backbone"
