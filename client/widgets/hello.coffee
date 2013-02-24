define [
  "sandbox/widget"
  "./hello/models/hello"
  "./hello/views/hello"
], (sandbox, Hello, HelloView) ->

  class HelloWidget extends sandbox.Widget

    events:
      click: ->
        console.log "hello!"

    initialize: ->
      @view = new HelloView
        model: new Hello
          name: "world"

    render: ->
      @$el.html @view.render().el
      @
