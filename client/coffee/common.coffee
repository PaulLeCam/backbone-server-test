require.config

  baseUrl: "/"

  deps: ["backbone", "app"]

  shim:
    backbone_lib:
      deps: ["underscore", "jquery"]
      exports: "Backbone"
    handlebars:
      exports: "Handlebars"

  paths:
    jquery: "libs/jquery"
    underscore: "libs/lodash"
    handlebars: "libs/handlebars.runtime"
    backbone_lib: "libs/backbone"
    backbone: "components/backbone"
