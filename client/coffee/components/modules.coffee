define [
  "underscore"
  "jquery"
], (_, $) ->

  # use {load, configure, initialize} api in config objects!
  class Modules

    #
    # Lifecycle
    #
    constructor: (config = {}) ->
      @_config = {}
      @_running = {}
      @configure config

    configure: (config = {}) ->
      if _.isArray config
        @setConfig item.key, item.value for item in config
      else
        for key, value of config
          console.log "configure should set", key, value
          @setConfig key, value #for key, value of config
      @

    initialize: (config) ->
      dfd = $.Deferred()
      if config?
        if _.isArray config # Only initialize white-listed keys
          promises = (@_run value for key, value of @_config when key in config)
        else if _.isString config # Single key
          if @has key then promises = [@_run @getConfig key]
          else
            err = "Could not initialize undefined key `#{ config }`"
            @_warn err
            dfd.reject new Error err
        else if _.isObject config # Configuration object, will overwrite default config
          @configure config
          promises = (@_run value for key, value of @_config)
        else # Bad parameter
          err = "Unhandled initialize argument"
          @_warn err, config
          dfd.reject new Error err
      else # Initialize all
        promises = (@_run value for key, value of @_config)

      if promises? and promises.length
        $.when.apply($, promises).then (res...) ->
          dfd.resolve res
        , dfd.reject

      else
        dfd.resolve()

      dfd.promise()

    #
    # Logs and default logger
    #
    _log: ->
      @_callLogger "log", arguments
      # @_callEmitter "log", arguments

    _warn: ->
      @_callLogger "warn", arguments
      # @_callEmitter "warn", arguments

    _error: ->
      @_callLogger "error", arguments
      # @_callEmitter "error", arguments

    _callLogger: (func, args) ->
      return unless @getConfig "debug"

      if @has "logger" # Custom module
        @get("logger")
          .fail(=> console.error "Could not load `logger` module", @getConfig "logger")
          .done (logger) ->
            if logger[func]? then logger[func].apply m, args
            else console.error "Could not find function `#{ func }` in `logger` module"

      else
        console[func].apply console, args

    _callEmitter: (type, args) ->
      @callRuns "pubsub", "trigger", type, args

    #
    # Config objects
    #
    has: (key) ->
      if key.indexOf(".") isnt -1
        arr = key.split "."
        (modules = @_config[arr.shift()]) and modules instanceof Modules and modules.has arr.join "."
      else @_config[key]?

    getConfig: (key) ->
      if key.indexOf(".") isnt -1
        arr = key.split "."
        (modules = @_config[arr.shift()]) and modules instanceof Modules and modules.getConfig arr.join "."
      else @_config[key]

    setConfig: (key, value = {}) ->
      return @ unless key?
      if key.indexOf(".") isnt -1
        arr = key.split "."
        (modules = @_config[arr.shift()]) and modules instanceof Modules and modules.setConfig arr.join("."), value
      else @_config[key] = value
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
    # Deferred creation and retrieval
    #
    get: (key, options = {}) ->
      dfd = $.Deferred()

      if _.isObject key
        if (config = key) and config.path?
          @_run(config).pipe dfd.resolve, dfd.reject
        else
          err = "Missing path in #get config Object"
          @_error err
          dfd.reject new Error err

      else if @runs key
        dfd.resolve @getRunning key

      else if @has key
        config = @getConfig key
        if _.isObject(config) and config.path?
          config.key = key
          @_run(config).pipe dfd.resolve, dfd.reject
        else dfd.resolve config

      else
        options.key ?= key
        @_run(options).pipe dfd.resolve, dfd.reject

      dfd.promise()

    set: (key, value) ->
      if value? then @setConfig key, value

      else if key instanceof Modules
        _.extend @_config, key._config
        _.extend @_running, key._running

      else if _.isObject(key) and (config = key) and config.data?
        if config.path? then @run config
        else @setConfig config.key, config.data

      else @_warn "unhandled #set arguments", key, value

      @

    #
    # Calls
    #
    callHas: (module, func, args...) ->
      if @has module
        @get(module)
          .fail(=> @_error "Could not load `#{ module }` module", @getConfig module)
          .done (m) =>
            if m[func]?
              res = m[func].apply m, args
              if res.fail?
                res.fail (args...) => @_warn "Call to function `#{ func }` in `#{ module }` module was rejected", args
              if res.done?
                res.done (args...) => @_log "Call to function `#{ func }` in `#{ module }` module was resolved", args
            else @_error "Could not find function `#{ func }` in `#{ module }` module"
        yes
      else no

    callRuns: (module, func, args...) ->
      if @runs module
        @get(module)
          .fail(=> @_error "Could not load `#{ module }` module", @getConfig module)
          .done (m) =>
            if m[func]?
              res = m[func].apply m, args
              if res.fail?
                res.fail (args...) => @_warn "Call to function `#{ func }` in `#{ module }` module was rejected", args
              if res.done?
                res.done (args...) => @_log "Call to function `#{ func }` in `#{ module }` module was resolved", args
            else @_error "Could not find function `#{ func }` in `#{ module }` module"
        yes
      else no

    #
    # Loading and creation
    #
    _run: (config = {}) ->
      dfd = $.Deferred()
      if config.path?
        @_load(config.path)
          .fail(dfd.reject)
          .done (func) =>
            @_factory(func, config).pipe dfd.resolve, dfd.reject
      else
        err = "No path provided"
        @_error err, config
        dfd.reject new Error err
      dfd.promise()

    _factory: (func, config) ->
      dfd = $.Deferred()
      config.data.context ?= @ if config.data? and _.isObject config.data
      e = func.call func, config.data
      @setRunning config.key, e
      dfd.resolve e
      dfd.promise()

    _load: (path) ->
      if @has "loader"
        loader = @getConfig "loader"
        loader.call loader, @, path
      else
        dfd = $.Deferred()
        require [path], dfd.resolve, dfd.reject
        dfd.promise()
