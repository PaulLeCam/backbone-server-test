define [
  "components/store"
], (Store) ->

  class ModelsStore extends Store
    _keys: {}
    _data: {}
    _stored: {}
    _path: "models"

  new ModelsStore App.models
