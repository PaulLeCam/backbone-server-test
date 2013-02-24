Backbone = require "backbone"
Handlebars = require "handlebars"
$ = require "jquery"

#
# Template
#

subviews = {}

Handlebars.addSubView = (view) ->
  subviews[view.cid] = view
  new Handlebars.SafeString "<view data-cid=\"#{ view.cid }\"></view>"

Handlebars.renderSubView = (cid) ->
  if view = subviews[cid]
    delete subviews[cid]
    view.render().el
  else ""

Handlebars.renderSubViews = ($el) ->
  $el.find("view").each (i, view) ->
    $view = $ view
    $view.replaceWith Handlebars.renderSubView $view.data "cid"

#
# MVC
#

Backbone.$ = $

class Model extends Backbone.Model

  emit: ->
    @trigger.apply @, arguments

  toJSON: ->
    json = super()
    json.id ?= @id
    json

class Collection extends Backbone.Collection

  emit: ->
    @trigger.apply @, arguments

class View extends Backbone.View

  emit: ->
    @trigger.apply @, arguments

  renderer: (html) ->
    @$el
      .attr("data-view", @cid)
      .html html
    Handlebars.renderSubViews @$el
    @el.outerHTML

#
# Public API
#

module.exports = {Model, Collection, View}
