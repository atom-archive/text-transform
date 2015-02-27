Layer = require './layer'
RawCharactersLayer = require './raw-characters-layer'
CharactersTransform = require './characters-transform'
LinesTransform = require './lines-transform'
TabsTransform = require './tabs-transform'
SoftWrapsTransform = require './soft-wraps-transform'

module.exports =
class TextBuffer
  constructor: ({text}) ->
    @rawCharactersLayer = new RawCharactersLayer(text)

  getRawCharactersLayer: -> @rawCharactersLayer

  getCharactersLayer: ->
    @charactersLayer ?= new Layer(@getRawCharactersLayer(), new CharactersTransform)

  getLinesLayer: ->
    @linesLayer ?= new Layer(@getCharactersLayer(), new LinesTransform)

  buildTabsLayer: (tabLength) ->
    new Layer(@getLinesLayer(), new TabsTransform(tabLength))

  buildSoftWrapsLayer: (params) ->
    new Layer(@buildTabsLayer(params.tabLength), new SoftWrapsTransform(params))
