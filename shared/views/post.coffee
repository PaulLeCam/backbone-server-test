run = (Backbone, tmpl, exp) ->

  class PostView extends Backbone.View

    template: @templater tmpl

    render: ->
      @renderer @template @model.toJSON()

  exp PostView

if typeof exports is "undefined" # Browser
  define ["backbone", "app_templates", "app_views"]
  , (Backbone, templates, store) ->
    run Backbone, templates["post"], (m) -> store[m.cid] = m

else # Node
  Backbone = require "../../components/backbone"
  template = require("fs").readFileSync("#{ __dirname }/../templates/post.htm").toString()
  run Backbone, template, (m) -> module.exports = m
