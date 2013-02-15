define [
  "underscore"
  "jquery"
  "./Modules"
], (_, $, Modules) ->

  class Store extends Modules

    setConfig: (key, value = {}) ->
      key ?= value.data.id ? value.data.cid if _.isObject(value) and value.data
      super key, value

    get: (key, path, data = {}) ->
      dfd = $.Deferred()

      if _.isObject key
        if (config = key) and config.path? and config.data?
          @run(config).pipe dfd.resolve, dfd.reject

        else if id = key.id ? key.cid
          key = id

      unless config?
        if @runs key
          dfd.resolve @getRunning key

        else if @has key
          config = @getConfig key
          if config.path?
            @run(config).pipe dfd.resolve, dfd.reject
          else
            dfd.resolve config

        else
          @run({key, path, data}).pipe dfd.resolve, dfd.reject

      dfd.promise()

    run: (config = {}) ->
      dfd = $.Deferred()
      return dfd.reject new Error "no path provided" unless config.path?
      @load(config.path)
        .fail(dfd.reject)
        .done (Cls) =>
          e = new Cls config.data
          config.key ?= e.id ? e.cid
          @setRunning config.key, e
          dfd.resolve e
      dfd.promise()
