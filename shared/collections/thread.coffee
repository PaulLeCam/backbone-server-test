run = (mvc, Post, exp) ->

  class Thread extends mvc.Collection

    model: Post

  exp Thread

if typeof exports is "undefined" # Browser
  define ["ext/framework", "models/post"], (framework, Post) ->
    run framework.mvc, Post, (c) -> c

else # Node
  run require("../../components/backbone-framework"), require("../models/post"), (c) -> module.exports = c
