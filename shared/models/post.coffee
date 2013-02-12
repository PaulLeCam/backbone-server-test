run = (Backbone, exp) ->

  class Post extends Backbone.Model
    

  exp Post

if typeof exports is "undefined" # Browser
  define ["backbone", "app_models"], (Backbone, store) ->
    run Backbone, (m) -> store[m.cid] = m

else # Node
  run require("../../components/backbone"), (m) -> module.exports = m
