define [
  "components/store"
], (Store) ->

  class CollectionsStore extends Store
    _keys: {}
    _data: {}
    _stored: {}
    _path: "collections"

  new CollectionsStore App.collections
