define [
  "jquery"
], ($) ->

  find: (selector, context = document) -> $(context).find selector
  data: (selector, args...) -> $(selector).data.apply $, args
  on: (selector, args...) -> $(selector).on.apply $, args
  off: (selector, args...) -> $(selector).off.apply $, args
  once: (selector, args...) -> $(selector).one.apply $, args
  ready: (callback) -> $ -> callback()
