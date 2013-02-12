run = (Backbone, Post, exp) ->

  class Thread extends Backbone.Collection
    
    model: Post

  exp Thread

if typeof exports is "undefined" # Browser
  define ["backbone", "models/post", "app_collections"], (Backbone, Post, store) ->
    run Backbone, Post, (c) -> store[c.cid] = c

else # Node
  run require("../../components/backbone"), require("../models/post"), (c) -> module.exports = c
