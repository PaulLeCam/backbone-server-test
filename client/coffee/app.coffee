define [
  "components/modules"
  # stores
  "app/collections"
  "app/models"
  "app/views"
  # app dependencies for build process
  "app/templates"
  "collections/thread"
  "views/post"
], (Modules, collections, models, views) ->

  app = (new Modules)
    .set("debug", yes)
    .set("pubsub", path: "components/pubsub")

  app.get("pubsub").done (ps) ->
    ps.on "all", (args...) -> console.log "pubsub emitted", args
    ps.trigger "got", "pubsub"

  app.set "models", # new Store App.models
    path: "components/store-factory"
    data: App.models

  setTimeout ->
    app.callRuns "pubsub", "trigger", "runs", "pubsub"
    app.get("models")
      .done (models) ->
        console.log "can I haz models?", models

        models
          .get("new post", "models/post", title: "hello")
          .done (m) ->
            console.log "created model", m
  , 1000

  app.callHas "models", "get",
    key: "new world"
    path: "models/post"
    data:
      title: "huho?"

  # Create new model
  models
    .get("new post", "models/post", title: "hello")
    .done (m) ->
      console.log "created model", m

  # Only get a specific collection from store
  collections
    .get("my posts")
    .done (c) ->
      console.log "got my posts", c

  # Initialize all views
  views.initialize().done (views) ->
    console.log "initialized views", views
