define [
  "core/util"
  "core/promise"
], (util, promise) ->

  widgets_els = {}
  widgets_types = {}

  load = (name) ->
    dfd = promise.deferred()
    require ["widgets/#{ name }"], dfd.resolve, dfd.reject
    dfd.promise()

  # initialize: (config) ->
  #   if config?
  #     if util.isArray config
  #       @start widget.load, widget.data for widget in config

  #     else if util.isObject config
  #       @start config.load, config.data

  start: (type, options) ->
    if options? # new one
      options = {el: options} unless util.isObject options
      load(type)
        .fail((err) -> console.warn "Could not load widget `#{ type }`")
        .done (Widget) ->
          w = new Widget options
          console.log "widget", w
          widgets_els[options.el] = w
          widgets_types[type] ?= {}
          widgets_types[type][options.el] = w
          w.start()

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
