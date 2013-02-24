define [
  "core/util"
  "core/events"
  "core/http"
  "core/promise"
  "core/command"
  "ext/mediator"
  "ext/framework"
], (util, events, http, promise, command, mediator, framework) ->

  util.extend {}, promise, command, mediator,
    {util},
    {events},
    {http},
    routing: framework.routing,
    mvc:
      Model: framework.mvc.Model
      Collection: framework.mvc.Model
