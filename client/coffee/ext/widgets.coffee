define [
  "core/util"
], (util) ->

  widgets_els = {}
  widgets_types = {}

  start: (type, options) ->
    if options? # new one
      options = {el: options} unless util.isObject options
      require ["widgets/#{ type }"]
      , (Widget) ->
          w = new Widget options
          widgets_els[options.el] = w
          widgets_types[type] ?= {}
          widgets_types[type][options.el] = w
          w.start()
      , (err) -> console.warn "Could not load widget `#{ type }`"

    else # restart existing one
      widgets_els[type]?.start()
    @

  stop: (el) ->
    widgets_els[el]?.stop()
    @

  remove: (el) ->
    widgets_els[el]?.remove()
    @

  startAll: (type) ->
    if widgets_types[type]?
      widget.start() for el, widget of widgets_types[type]
    @

  stopAll: (type) ->
    if widgets_types[type]?
      widget.stop() for el, widget of widgets_types[type]
    @

  removeAll: (type) ->
    if widgets_types[type]?
      widget.remove() for el, widget of widgets_types[type]
    @
