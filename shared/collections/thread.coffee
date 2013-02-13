run = (Backbone, Post, exp) ->

  class Thread extends Backbone.Collection

    model: Post

  exp Thread

if typeof exports is "undefined" # Browser
  define ["backbone", "models/post"], (Backbone, Post) ->
    run Backbone, Post, (c) -> c

else # Node
  run require("../../components/backbone"), require("../models/post"), (c) -> module.exports = c
