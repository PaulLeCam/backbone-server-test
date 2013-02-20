define [
  "underscore"
  "backbone"
], (_, Backbone) ->

  ->
    _.extend {}, Backbone.Events
