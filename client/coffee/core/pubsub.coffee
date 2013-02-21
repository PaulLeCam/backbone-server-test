define [
  "./util"
  "./events"
], (util, Events) ->

  pubsub = util.extend {}, Events
  pubsub.emit = pubsub.trigger

  pubsub
