define [
  "core/util"
  "core/events"
  "core/http"
  "core/promise"
  "core/command"
  "ext/mediator"
  "ext/framework"
], (util, events, http, promise, command, mediator, framework) ->

  util.extend {}, {util}, {events}, {http}, promise, command, mediator, framework
