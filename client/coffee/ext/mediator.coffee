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
  listenPipe: (emitter, events) ->
    emitter.on events, (args...) ->
      args.unshift events
      pubsub.emit.apply pubsub, args
  emitPipe: (listener, events) ->
    @on events, (args...) ->
      args.unshift events
      listener.emit.apply listener, args
  start: ->
    @emit "app:start"
