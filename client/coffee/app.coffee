define [
  # stores
  "app/collections"
  "app/models"
  "app/views"
  # app dependencies for build process
  "app/templates"
  "collections/thread"
  "views/post"
], (collections, models, views) ->

  # Only get a specific collection from store
  collections
    .get(name: "my posts")
    .done (col) ->
      console.log "got my posts", col

  # Initialize all views
  views.initialize().done (views) ->
    console.log "initialized views", views
