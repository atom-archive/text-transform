Layer = require './layer'
RawCharactersLayer = require './raw-characters-layer'
CharactersTransform = require './characters-transform'
LinesTransform = require './lines-transform'
HardTabsTransform = require './hard-tabs-transform'
SoftTabsTransform = require './soft-tabs-transform'
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

  buildHardTabsLayer: (tabLength) ->
    new Layer(@getLinesLayer(), new HardTabsTransform(tabLength))

  buildSoftTabsLayer: (tabLength) ->
    new Layer(@buildHardTabsLayer(tabLength), new SoftTabsTransform(tabLength))

  buildSoftWrapsLayer: (params) ->
    new Layer(@buildHardTabsLayer(params.tabLength), new SoftWrapsTransform(params))
