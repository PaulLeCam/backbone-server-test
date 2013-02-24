define [
  "sandbox/widget"
  "../templates/hello"
], (sandbox, tmpl) ->

  class HelloView extends sandbox.mvc.View

    template: tmpl
