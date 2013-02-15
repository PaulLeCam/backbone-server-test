define [
  "underscore"
  "jquery"
], (_, $) ->

  class Modules

    #
    # Lifecycle
    #
    constructor: (items = []) ->
      @_config = {}
      @_running = {}
      @setConfig item.key, item for item in items

    initialize: ->
      dfd = $.Deferred()
      promises = (@run config for key, config of @_config)
      $.when.apply($, promises).then (res...) ->
        dfd.resolve res
      , dfd.reject
      dfd.promise()

    #
    # Logs
    #
    _logDefault: ->
      console?.log.apply console, arguments

    _warnDefault: ->
      console?.warn.apply console, arguments

    _errorDefault: ->
      console?.error.apply console, arguments

    #
    # Config objects
    #
    has: (key) ->
      if key.indexOf(".") isnt -1
        arr = key.split "."
        (modules = @_config[arr.shift()]) and modules instanceof Modules and modules.has arr.join "."
      else @_config[key]?

    getConfig: (key) ->
      @_config[key]

    setConfig: (key, value = {}) ->
      return @ unless key?
      @_config[key] = value
      @

    setPath: (key, path) ->
      @setConfig key, {key, path}

    #
    # Instanciated
    #
    runs: (key) ->
      if key.indexOf(".") isnt -1
        arr = key.split "."
        (modules = @_running[arr.shift()]) and modules instanceof Modules and modules.runs arr.join "."
      else @_running[key]?

    getRunning: (key) ->
      @_running[key]

    setRunning: (key, value = {}) ->
      return @ unless key?
      @_running[key] = value
      @setConfig key unless @has key
      @

    #
    # Deferred creation and retieval
    #
    get: (key, path, data = {}) ->
      dfd = $.Deferred()

      if _.isObject key
        if (config = key) and config.path? and config.data?
          @run(config).pipe dfd.resolve, dfd.reject
        else
          err = "missing path or data in #get config Object"
          @_errorDefault err
          dfd.reject new Error err

      else if @runs key
        dfd.resolve @getRunning key

      else if @has key
        config = @getConfig key
        if config.path? then @run(config).pipe dfd.resolve, dfd.reject
        else dfd.resolve config

      else @run({key, path, data}).pipe dfd.resolve, dfd.reject

      dfd.promise()

    set: (key, path, data) ->
      if data?
        if path? then @run {key, path, data}
        else @setConfig key, data

      else if key instanceof Modules
        _.extend @_config, modules._config
        _.extend @_running, modules._running

      else if path instanceof Modules
        @setConfig key, modules

      else if _.isObject(key) and (config = key) and config.data?
        if config.path? then @run config
        else @setConfig config.key, config.data

      else @_warnDefault "unhandled #set arguments", key, path, data

      @

    #
    # Loading and creation
    #
    run: (config = {}) ->
      dfd = $.Deferred()
      return dfd.reject new Error "no path provided" unless config.path?
      @load(config.path)
        .fail(dfd.reject)
        .done (func) =>
          e = func.call func, @, config.data
          @setRunning config.key, e
          dfd.resolve e
      dfd.promise()

    load: (path) ->
      dfd = $.Deferred()
      require [path], dfd.resolve, dfd.reject
      dfd.promise()
