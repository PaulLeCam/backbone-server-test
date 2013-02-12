Backbone = require "backbone"
Handlebars = require "handlebars"
jQuery = require "jquery"

newBackbone = Backbone

newBackbone.$ = jQuery

class newBackbone.Model extends Backbone.Model

  toJSON: ->
    json = super()
    json.id ?= @cid
    json

class newBackbone.View extends Backbone.View

  @templater = (tmpl) -> Handlebars.compile tmpl

  renderer: (html) ->
    @$el
      .attr("data-view", @cid)
      .html html
    @el.outerHTML

module.exports = newBackbone
