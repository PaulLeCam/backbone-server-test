module.exports = (path) ->

  (req, res, next) ->

    res.locals.app_data =
      data: []
      views: []

    res.locals.collection = (type, models, name) ->
      Collection = require "#{ path }/collections/#{ type }"
      collection = new Collection models
      res.locals.app_data.data.push
        key: name
        load: "collections/#{ type }"
        data: collection.toJSON()
      collection

    res.locals.model = (type, data, name) ->
      Model = require "#{ path }/models/#{ type }"
      model = new Model data
      res.locals.app_data.data.push
        key: name
        load: "models/#{ type }"
        data: model.toJSON()
      model

    res.locals.view = (type, params, name) ->
      View = require "#{ path }/views/#{ type }"
      view = new View params
      params.cid = view.cid
      res.locals.app_data.views.push
        key: name
        load: "views/#{ type }"
        data: params
      view.render()

    next()
