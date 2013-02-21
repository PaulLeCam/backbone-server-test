define [
  "./promise"
], (promise) ->

  callbacks = {}

  register: (name, callback) ->
    callbacks[name] = callback

  request: (name, args...) ->
    dfd = promise.deferred()

    if cb = callbacks[name]
      args.unshift dfd
      cb.apply null, args
    else dfd.reject new Error "Undefined callback #{ name }"

    dfd.promise()
