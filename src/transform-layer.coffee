Point = require './point'

module.exports =
class TransformLayer
  constructor: (@transform, @source) ->
    @transform.setSource(@source)

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

  sourceToTarget: (sourcePoint) ->
    sourcePoint = @source.sourceToTarget(sourcePoint)

    sourceTraversal = Point(0, 0)
    targetTraversal = Point(0, 0)

    for region in @getRegions()
      nextSourceTraversal = sourceTraversal.traverse(region.sourceTraversal)
      break if nextSourceTraversal.isGreaterThan(sourcePoint)
      sourceTraversal = nextSourceTraversal
      targetTraversal = targetTraversal.traverse(region.targetTraversal)

    overshoot = Point(sourcePoint.rows - sourceTraversal.rows, sourcePoint.columns - sourceTraversal.columns)
    targetTraversal.traverse(overshoot)
