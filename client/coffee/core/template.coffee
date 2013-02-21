define [
  "handlebars"
], (Handlebars) ->

  Handlebars.registerHelper "safe", (html) ->
    new Handlebars.SafeString html

  Handlebars
