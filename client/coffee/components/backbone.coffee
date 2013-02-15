define [
  "jquery"
  "backbone_lib"
  "handlebars"
  "app/models"
  "app/views"
], ($, Backbone, Handlebars, models, views) ->

  newBackbone = Backbone

  class newBackbone.Model extends Backbone.Model

    constructor: (params = {}) ->
      if (id = params.id or params.cid) and self = models.getRunning id
        self.set params, silent: yes
        self
      else
        super params
        @

    toJSON: ->
      json = super()
      json.id ?= @cid
      json

  class newBackbone.View extends Backbone.View

    @templater = (tmpl) -> Handlebars.template tmpl

    constructor: (params = {}) ->
      if (id = params.id or params.cid) and self = views.getRunning id
        self.initialize params
        self
      else
        super params
        @

    events:
      click: (e) ->
        console.log "clicked #{ @cid }"

    initialize: (params = {}) ->
      if not params.el and params.cid
        $el = $ "[data-view=#{ params.cid }]"
        @setElement $el if $el.length

    renderer: (html) ->
      @$el
        .attr("data-view", @cid)
        .html html
      @el

  newBackbone
