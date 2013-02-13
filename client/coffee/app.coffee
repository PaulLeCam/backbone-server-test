define [
  "app/collections"
  "app/models"
  "app/views"
], (collections, models, views) ->

  # Only get a specifi collection from store
  collections
    .get(name: "my posts")
    .done (col) ->
      console.log "got my posts", col

  # Initialize all views
  views.initialize().done (views) ->
    console.log "initialized views", views
