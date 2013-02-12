module.exports = (path) ->

  (req, res, next) ->

    res.locals.app_data =
      collections: {}
      models: {}
      views: {}

    res.locals.collection = (name, id, params) ->
      Collection = require "#{ path }/collections/#{ name }"
      collection = new Collection params
      res.locals.app_data.collections[id] = collection
      collection

    res.locals.model = (name, params) ->
      Model = require "#{ path }/models/#{ name }"
      model = new Model params
      res.locals.app_data.models[model.cid] = model
      model
      
    res.locals.view = (name, params) ->
      View = require "#{ path }/views/#{ name }"
      view = new View params
      res.locals.app_data.views[view.cid] = params
      view.render()

    next()
