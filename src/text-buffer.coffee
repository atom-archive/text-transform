TransformLayer = require './transform-layer'
CharactersLayer = require './characters-layer'
LinesTransform = require './lines-transform'

module.exports =
class TextBuffer
  constructor: ({text}) ->
    @charactersLayer = new CharactersLayer(text)
    @linesLayer = new TransformLayer(@charactersLayer, new LinesTransform)

  buildTransformLayer: (transform) ->
    new TransformLayer(@linesLayer, transform)
