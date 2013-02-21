run = (mvc, exp) ->

  exp class Post extends mvc.Model


if typeof exports is "undefined" # Browser
  define ["ext/framework"], (framework) ->
    run framework.mvc, (c) -> c

else # Node
  run require("../../components/backbone"), (c) -> module.exports = c
