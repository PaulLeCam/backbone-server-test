module.exports = (path) ->

  (req, res, next) ->

    res.locals.app_data =
      collections: []
      models: []
      views: []

    res.locals.collection = (type, models, name) ->
      Collection = require "#{ path }/collections/#{ type }"
      collection = new Collection models
      res.locals.app_data.collections.push
        path: "collections/#{ type }"
        data: collection.toJSON()
        key: name if name?
      collection

    res.locals.model = (type, data, name) ->
      Model = require "#{ path }/models/#{ type }"
      model = new Model data
      res.locals.app_data.models.push
        path: "models/#{ type }"
        data: model.toJSON()
        key: name if name?
      model

    res.locals.view = (type, params, name) ->
      View = require "#{ path }/views/#{ type }"
      view = new View params
      params.cid = view.cid
      res.locals.app_data.views.push
        path: "views/#{ type }"
        data: params
        key: name if name?
      view.render()

    next()
