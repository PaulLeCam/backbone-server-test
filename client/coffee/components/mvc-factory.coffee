define [
  "sandbox/component"
], (sandbox) ->

    initialize: (config) ->
      dfd = sandbox.deferred()

      if config?
        if sandbox.util.isArray config
          promises = (@instanciate item for item in config)
          sandbox.when.apply(sandbox, promises).then (res...) ->
            dfd.resolve res
          , dfd.reject

        else if sandbox.util.isObject config
          @instanciate(config).pipe dfd.resolve, dfd.reject
          
        else
          dfd.reject new Error "Unhandled initialize argument"

      else
        dfd.resolve()

      dfd.promise()

    instanciate: (config = {}) ->
      dfd = sandbox.deferred()
      if config.load?
        @load(config.load)
          .fail(dfd.reject)
          .done (Cls) =>
            @factory(Cls, config).pipe dfd.resolve, dfd.reject
      else
        dfd.reject new Error "No load path provided"
      dfd.promise()

    load: (path) ->
      dfd = sandbox.deferred()
      require [path], dfd.resolve, dfd.reject
      dfd.promise()

    factory: (Cls, config) ->
      dfd = sandbox.deferred()
      res = new Cls config.data
      if config.fetch and config.fetch is on
        res.fetch().then dfd.resolve, dfd.reject
      else
        dfd.resolve res
      dfd.promise()
