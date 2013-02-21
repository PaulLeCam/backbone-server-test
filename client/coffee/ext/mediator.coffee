define [
  "core/dom"
  "core/pubsub"
  "core/routing"
], (dom, pubsub, routing) ->

  pubsub.on "app:start", ->
    routing.history.start
      pushState: yes

  on: -> pubsub.on.apply pubsub, arguments
  off: -> pubsub.off.apply pubsub, arguments
  once: -> pubsub.once.apply pubsub, arguments
  emit: -> pubsub.emit.apply pubsub, arguments
  listenPipe: (emitter, events = "all") ->
    emitter.on events, ->
      pubsub.emit.apply pubsub, arguments
  emitPipe: (listener, events = "all") ->
    @on events, ->
      listener.emit.apply listener, arguments
  start: ->
    @emit "app:start"
