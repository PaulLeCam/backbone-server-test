run = (mvc, Post, tmpl, exp) ->

  class PostView extends mvc.View

    Model: Post
    template: tmpl

    render: ->
      @renderer @template @model.toJSON()

  exp PostView

if typeof exports is "undefined" # Browser
  define ["ext/framework", "models/post", "templates/post"]
  , (framework, Post, template) ->
    run framework.mvc, Post, template, (c) -> c

else # Node
  Handlebars = require "handlebars"
  Backbone = require "../../components/backbone-framework"
  Post = require "../models/post"
  template = Handlebars.compile require("fs").readFileSync("#{ __dirname }/../templates/post.htm").toString()
  run Backbone, Post, template, (c) -> module.exports = c
