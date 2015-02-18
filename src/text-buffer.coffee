Layer = require './layer'
CharactersLayer = require './characters-layer'
LinesTransform = require './lines-transform'
TabsTransform = require './tabs-transform'

module.exports =
class TextBuffer
  constructor: ({text}) ->
    @charactersLayer = new CharactersLayer(text)

  getCharactersLayer: ->
    @charactersLayer

  getLinesLayer: ->
    @linesLayer ?= new Layer(@charactersLayer, new LinesTransform)

  buildTabsLayer: (tabLength) ->
    new Layer(@getLinesLayer(), new TabsTransform(tabLength))
