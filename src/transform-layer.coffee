Point = require './point'

module.exports =
class TransformLayer
  constructor: (@source, @transform) ->
    @transform.initialize(@source)

  getRegions: ->
    regions = []
    sourceStartPosition = Point.ZERO
    targetStartPosition = Point.ZERO

    loop
      region = @transform.getNextRegion({sourceStartPosition, targetStartPosition})
      break unless region.sourceTraversal.isGreaterThan(Point.ZERO) or region.targetTraversal.isGreaterThan(Point.ZERO)
      sourceStartPosition = sourceStartPosition.traverse(region.sourceTraversal)
      targetStartPosition = sourceStartPosition.traverse(region.targetTraversal)
      regions.push(region)

    regions

  fromPositionInLayer: (position, layer) ->
    if @source isnt layer
      sourcePosition = @source.fromPositionInLayer(position, layer)
    else
      sourcePosition = position

    sourceTraversal = Point.ZERO
    targetTraversal = Point.ZERO

    for region in @getRegions()
      nextSourceTraversal = sourceTraversal.traverse(region.sourceTraversal)
      break if nextSourceTraversal.isGreaterThan(sourcePosition)
      sourceTraversal = nextSourceTraversal
      targetTraversal = targetTraversal.traverse(region.targetTraversal)

    overshoot = Point(sourcePosition.rows - sourceTraversal.rows, sourcePosition.columns - sourceTraversal.columns)
    targetTraversal.traverse(overshoot)

  toPositionInLayer: (position, layer) ->
    targetPosition = position

    sourceTraversal = Point.ZERO
    targetTraversal = Point.ZERO

    for region in @getRegions()
      nextTargetTraversal = targetTraversal.traverse(region.targetTraversal)
      break if nextTargetTraversal.isGreaterThan(targetPosition)
      targetTraversal = nextTargetTraversal
      sourceTraversal = sourceTraversal.traverse(region.sourceTraversal)

    overshoot = Point(targetPosition.rows - targetTraversal.rows, targetPosition.columns - targetTraversal.columns)
    sourcePosition = sourceTraversal.traverse(overshoot)

    if @source isnt layer
      @source.toPositionInLayer(sourcePosition, layer)
    else
      sourcePosition
