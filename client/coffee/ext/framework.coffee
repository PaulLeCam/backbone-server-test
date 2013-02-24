define [
  "core/util"
  "core/dom"
  "core/mvc"
  "core/template"
  "core/routing"
  "core/store"
], (util, dom, mvc, template, routing, Store) ->

  #
  # Template extension
  #

  subviews = new Store

  template.addSubView = (view) ->
    subviews.set view.cid, view
    new template.SafeString "<view data-cid=\"#{ view.cid }\"></view>"

  template.renderSubView = (cid) ->
    if view = subviews.get cid
      subviews.delete cid
      view.render().el
    else ""

  template.renderSubViews = ($el) ->
    $el.find("view").each (i, view) ->
      $view = dom.find view, $el
      $view.replaceWith template.renderSubView $view.data "cid"

  #
  # MVC extension
  #

  class Model extends mvc.Model

    store: new Store

    constructor: (params = {}) ->
      if (id = params.id or params.cid) and self = @store.get id
        self.set params, silent: yes
      else
        self = super params
        key = @id ? @cid
        @store.set key, self
      self

    emit: ->
      @trigger.apply @, arguments

  class Collection extends mvc.Collection

    emit: ->
      @trigger.apply @, arguments

  class View extends mvc.View

    events:
      click: (e) ->
        console.log "clicked #{ @cid }"

    initialize: (params = {}) ->
      if params.model and not (params.model instanceof mvc.Model)
        if @Model then @model = new @Model params.model
        else console.error "Invalid model", params.model

      if params.collection and not (params.collection instanceof mvc.Collection)
        if @Collection then @collection = new @Collection params.collection
        else console.error "Invalid collection", params.collection

      if not params.el and params.cid
        $el = dom.find "[data-view=#{ params.cid }]"
        @setElement $el if $el.length

    emit: ->
      @trigger.apply @, arguments

    render: ->
      @renderer @template @model.toJSON()

    renderer: (html) ->
      @$el
        .attr("data-view", @cid)
        .html html
      template.renderSubViews @$el
      @

  #
  # Widget
  #

  class Widget extends View

    start: ->
      if @rendered then @delegateEvents()
      else
        @render()
        @rendered = yes

    stop: ->
      @undelegateEvents()

  #
  # Public API
  #

  mvc = {Model, View, Collection}
  {mvc, template, routing, Widget}
