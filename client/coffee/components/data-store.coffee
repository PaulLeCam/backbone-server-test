define [
  "sandbox/component"
  "./mvc-factory"
], (sandbox, factory) ->

  class DataStore

    constructor: (config = {}) ->
      return new DataStore config unless @ instanceof DataStore

      @config = new sandbox.Store
      @instances = new sandbox.Store

      @configure config

    configure: (config = {}) ->
      if sandbox.util.isArray config
        @config.set item.key, item for item in config
      else
        @config.set key, value for key, value of config
      @

    initialize: (config) ->
      dfd = sandbox.deferred()

      # Custom initialization
      if config?
        # Only initialize white-listed keys
        if sandbox.util.isArray config
          promises = []
          for key in config
            if value = @config.get key
              value.key ?= key
              promises.push @instanciate value
        # Single key
        else if _.isString config
          if value = @config.get key
            value.key ?= key
            promises = [@instanciate value]
          else
            dfd.reject new Error "Could not initialize undefined key `#{ config }`"

        # Configuration object, will overwrite default config
        else if _.isObject config
          promises = []
          for key, value of config
            @config.set key, value 
            value.key ?= key
            promises.push @instanciate value
        # Bad parameter
        else 
          dfd.reject new Error "Unhandled initialize argument"

      # Initialize all
      else
        promises = []
        for key, value of config
          value.key ?= key
          promises.push @instanciate value

      if promises? and promises.length
        sandbox.when.apply(sandbox, promises).then (res...) ->
          dfd.resolve res
        , dfd.reject
      else
        dfd.resolve()

      dfd.promise()

    instanciate: (config) ->
      factory.instanciate config

    get: (key, options = {}) ->
      dfd = sandbox.deferred()

      # Custom configuration Object
      if _.isObject key
        @instanciate(key).pipe dfd.resolve, dfd.reject

      # Already instanciated
      else if @instances.has key 
        dfd.resolve @instances.get key

      # In config
      else if @config.has key
        config = @config.get key
        if _.isObject(config) and config.load?
          config.key ?= key
          @instanciate(config).pipe dfd.resolve, dfd.reject
        else
          dfd.resolve config

      # Try to instanciate with options
      else
        options.key ?= key
        @instanciate(options).pipe dfd.resolve, dfd.reject

      dfd.promise()

    set: (key, value) ->
      if sandbox.util.isObject key
        @_set k, v for k, f of key
      else
        @_set key, value
      @

    _set: (key, value) ->
      return unless value
      if value instanceof sandbox.mvc.Model or value instanceof sandbox.mvc.Collection
        @instances.set key, value
      else
        @config.set key, value
