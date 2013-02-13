run = (Backbone, tmpl, exp) ->

  class PostView extends Backbone.View

    template: @templater tmpl

    render: ->
      @renderer @template @model.toJSON()

  exp PostView

if typeof exports is "undefined" # Browser
  define ["backbone", "app/templates"]
  , (Backbone, templates) ->
    run Backbone, templates["post"], (c) -> c

else # Node
  Backbone = require "../../components/backbone"
  template = require("fs").readFileSync("#{ __dirname }/../templates/post.htm").toString()
  run Backbone, template, (c) -> module.exports = c
