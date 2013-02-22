define [
  "sandbox/widget"
  "components/mvc-factory"
  "components/data-store"
  "services/data"
  "models/post"
], (sandbox, factory, DataStore, data, Post) ->

  sandbox.on "app:start", ->
    console.log "sandbox app started!"

  factory.initialize(App.views)
    .fail((err) -> console.error err)
    .done (res) ->
      console.log "views", res

  data.get("my posts").done (res) ->
    console.log "got my posts", res

  # Simple key/value
  data.set "test1", title: "test1"
  # Factory configuration
  data.set "test2",
    load: "models/post"
    data:
      title: "test2"
  # Model or Collection instance
  data.set "test3", new Post title: "test3"

  data.get("test1").done (res) ->
    console.log "test1 res", res

  data.get("test2").done (res) ->
    console.log "test2 res", res

  data.get("test3").done (res) ->
    console.log "test3 res", res

  sandbox.start()
