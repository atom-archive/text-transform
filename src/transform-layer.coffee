Point = require './point'

module.exports =
class TransformLayer
  constructor: (@source, @transform) ->
    @transform.initialize(@source)

  getRegions: ->
    regions = []
    sourceStartPosition = Point(0, 0)
    targetStartPosition = Point(0, 0)

    loop
      region = @transform.getNextRegion({sourceStartPosition, targetStartPosition})
      break unless region.sourceTraversal.isGreaterThan(Point.ZERO) or region.targetTraversal.isGreaterThan(Point.ZERO)
      sourceStartPosition = sourceStartPosition.traverse(region.sourceTraversal)
      targetStartPosition = sourceStartPosition.traverse(region.targetTraversal)
      regions.push(region)

    regions

  fromPositionInLayer: (position, layer) ->
    if @source isnt layer
      sourcePosition = @source.fromLayerPosition(position)
    else
      sourcePosition = position

    sourceTraversal = Point(0, 0)
    targetTraversal = Point(0, 0)

    for region in @getRegions()
      nextSourceTraversal = sourceTraversal.traverse(region.sourceTraversal)
      break if nextSourceTraversal.isGreaterThan(sourcePosition)
      sourceTraversal = nextSourceTraversal
      targetTraversal = targetTraversal.traverse(region.targetTraversal)

    overshoot = Point(sourcePosition.rows - sourceTraversal.rows, sourcePosition.columns - sourceTraversal.columns)
    targetTraversal.traverse(overshoot)