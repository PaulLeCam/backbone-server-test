define [
  "core/util"
  "core/events"
  "core/http"
  "core/promise"
  "core/command"
  "core/store"
  "ext/framework"
], (util, events, http, promise, command, Store, framework) ->

  util.extend {}, {util}, {events}, {http}, promise, command, {Store}, framework
