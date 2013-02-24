define [
  "core/util"
  "core/dom"
  "core/events"
  "core/promise"
  "core/command"
  "ext/mediator"
  "ext/framework"
], (util, dom, events, promise, command, mediator, framework) ->

  util.extend {}, promise, mediator, framework,
    {util},
    {dom},
    {events},
    request: command.request
