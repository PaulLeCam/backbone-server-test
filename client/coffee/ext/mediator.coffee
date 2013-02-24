define [
  "core/pubsub"
  "./widgets"
], (pubsub, widgets) ->

  # Move to routing service
  #
  # pubsub.on "app:start", ->
  #   routing.history.start
  #     pushState: yes

  widgets: widgets

  on: ->
    pubsub.on.apply pubsub, arguments
    @
  off: ->
    pubsub.off.apply pubsub, arguments
    @
  once: ->
    pubsub.once.apply pubsub, arguments
    @
  emit: ->
    pubsub.emit.apply pubsub, arguments
    @

  start: ->
    @emit "app:start"

  pipeFrom: (target, events, alias) ->
    target.on events, (args...) ->
      args.unshift alias ? events
      pubsub.emit.apply pubsub, args
    @
  unpipeFrom: (target, events, alias) ->
    target.off events, (args...) ->
      args.unshift alias ? events
      pubsub.emit.apply pubsub, args
    @

  pipeTo: (target, events, alias) ->
    @on events, (args...) ->
      args.unshift alias ? events
      target.emit.apply target, args
    @
  unpipeTo: (target, events, alias) ->
    @off events, (args...) ->
      args.unshift alias ? events
      target.emit.apply target, args
    @
