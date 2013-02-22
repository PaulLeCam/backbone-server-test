define [
  "backbone"
], (Backbone) ->

  events = Backbone.Events
  events.emit = events.trigger

  events
