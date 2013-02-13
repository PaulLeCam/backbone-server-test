define [
  "components/store"
], (Store) ->

  class ViewsStore extends Store
    _keys: {}
    _data: {}
    _stored: {}
    _path: "views"

  new ViewsStore App.views
