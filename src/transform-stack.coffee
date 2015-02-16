TransformLayer = require './transform-layer'
BaseLayer = require './base-layer'

module.exports =
class TransformStack
  constructor: (sourceText) ->
    @topLayer = @baseLayer = new BaseLayer(sourceText)

  addTransform: (transform) ->
    @topLayer = new TransformLayer(transform, @topLayer)

  getRegions: ->
    @topLayer.getRegions()

  sourceToTarget: (point) ->
    @topLayer.sourceToTarget(point)
