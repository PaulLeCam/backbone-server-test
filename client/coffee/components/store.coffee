define [
  "underscore"
  "jquery"
  "./modules"
], (_, $, Modules) ->

  class Store extends Modules

    setConfig: (key, value = {}) ->
      key ?= value.data.id ? value.data.cid if _.isObject(value) and value.data
      @_config[key] = value if key?
      @

    _factory: (Cls, config) ->
      dfd = $.Deferred()
      e = new Cls config.data
      config.key ?= e.id ? e.cid
      @setRunning config.key, e
      dfd.resolve e
      dfd.promise()
