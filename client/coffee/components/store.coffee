define [
  "underscore"
  "jquery"
], (_, $) ->

  class Store

    constructor: (items = []) ->
      @setData item.name, item for item in items

    initialize: ->
      dfd = $.Deferred()
      promises = (@create params for key, params of @_data)
      $.when.apply($, promises).then (res...) ->
        dfd.resolve res
      , dfd.reject
      dfd.promise()

    #
    # Keys
    #
    addKey: (key) ->
      @_keys[key] = on

    hasKey: (key) ->
      @_keys[key]?

    #
    # Raw data
    #
    hasData: (key) ->
      @_data[key]?

    getData: (key) ->
      @_data[key]

    setData: (key, params = {}) ->
      key ?= params.data?.id ? params.data?.cid
      @_data[key] = params
      @addKey key
      @

    #
    # Store
    #
    hasStored: (key) ->
      @_stored[key]?

    getStored: (key) ->
      @_stored[key]

    setStored: (key, data = {}) ->
      return @ unless key
      @_stored[key] = data
      @addKey key
      @

    # Should be able to handle object with name, data.id or data.cid, id or cid
    # If type and data, create
    get: (params) ->
      dfd = $.Deferred()
      key =
        if _.isObject params
          if params.name then params.name
          else if params.data then params.data.id ? params.data.cid
          else null
        else params

      if key?
        if stored = @getStored key then dfd.resolve stored
        else if (data_params = @getData key) and data_params.type and data_params.data
          @create(data_params).pipe dfd.resolve, dfd.reject

      else if _.isObject(params) and params.type and params.data
        @create(params).pipe dfd.resolve, dfd.reject

      else
        dfd.reject new Error "No key attribute found"

      dfd.promise()

    create: (params = {}) ->
      dfd = $.Deferred()
      @load(params.type)
        .fail(dfd.reject)
        .done (Cls) =>
          e = new Cls params.data
          @setStored params.name, e
          dfd.resolve e
      dfd.promise()

    load: (type) ->
      dfd = $.Deferred()
      require ["#{ @_path }/#{ type }"]
      , dfd.resolve
      , dfd.reject
      dfd.promise()
