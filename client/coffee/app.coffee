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
    .setConfig("test", "value")

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
