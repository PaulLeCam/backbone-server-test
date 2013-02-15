run = (Backbone, exp) ->

  exp class Post extends Backbone.Model


if typeof exports is "undefined" # Browser
  define ["backbone"], (Backbone) ->
    run Backbone, (c) -> c

else # Node
  run require("../../components/backbone"), (c) -> module.exports = c
