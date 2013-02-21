define [
  "core/util"
  "core/dom"
  "core/events"
  "core/promise"
  "core/command"
  "ext/mediator"
  "ext/framework"
], (util, dom, events, promise, command, mediator, framework) ->

  util.extend {}, {util}, {dom}, {events}, promise, mediator, framework, request: command.request
