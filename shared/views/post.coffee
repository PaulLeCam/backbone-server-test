run = (mvc, Post, tmpl, exp) ->

  class PostView extends mvc.View

    Model: Post
    template: @templater tmpl

    render: ->
      @renderer @template @model.toJSON()

  exp PostView

if typeof exports is "undefined" # Browser
  define ["ext/framework", "models/post", "app/templates"]
  , (framework, Post, templates) ->
    run framework.mvc, Post, templates["post"], (c) -> c

else # Node
  Backbone = require "../../components/backbone"
  Post = require "../models/post"
  template = require("fs").readFileSync("#{ __dirname }/../templates/post.htm").toString()
  run Backbone, Post, template, (c) -> module.exports = c
