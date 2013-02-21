define [
  "./util"
], (util) ->

  class Store

    constructor: (@data = {}) ->
      return new Store @data unless @ instanceof Store

    has: (key) ->
      @data[key]?

    get: (key) ->
      @data[key]

    set: (key, value) ->
      if util.isObject key
        util.extend @data, key
      else if key?
        @data[key] = value
      @

    delete: (key) ->
      delete @data[key]
      @
