Point = require './point'

module.exports =
class Layer
  constructor: (@source, @transform) ->
    @transform.initialize(@source)
    @regions = @buildRegions()

  buildRegions: ->
    regions = []
    sourceStartPosition = Point.ZERO
    targetStartPosition = Point.ZERO

    loop
      region = @transform.getNextRegion({sourceStartPosition, targetStartPosition})
      break unless region.sourceTraversal.isGreaterThan(Point.ZERO) or region.targetTraversal.isGreaterThan(Point.ZERO)
      sourceStartPosition = sourceStartPosition.traverse(region.sourceTraversal)
      targetStartPosition = targetStartPosition.traverse(region.targetTraversal)
      regions.push(region)

    regions

  getContent: ->
    content = ""
    for region in @regions
      content += region.content
    content

  fromPositionInLayer: (position, layer) ->
    if @source isnt layer
      sourcePosition = @source.fromPositionInLayer(position, layer)
    else
      sourcePosition = position

    sourceTraversal = Point.ZERO
    targetTraversal = Point.ZERO

    for region in @regions
      nextSourceTraversal = sourceTraversal.traverse(region.sourceTraversal)
      break if nextSourceTraversal.isGreaterThan(sourcePosition)
      sourceTraversal = nextSourceTraversal
      targetTraversal = targetTraversal.traverse(region.targetTraversal)

    overshoot = sourceTraversal.traversal(sourcePosition)
    targetTraversal.traverse(overshoot)

  toPositionInLayer: (position, layer) ->
    targetPosition = position

    sourceTraversal = Point.ZERO
    targetTraversal = Point.ZERO

    for region in @regions
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

  positionOf: (string, start=Point(0, 0)) ->
    if sourcePosition = @source.positionOf(string, @toPositionInLayer(start, @source))
      pos =  @fromPositionInLayer(sourcePosition, @source)
      return pos

  slice: (start, end=@getEndPosition()) ->
    @source.slice(@toPositionInLayer(start, @source), @toPositionInLayer(end, @source))

  getEndPosition: ->
    targetTraversal = Point.ZERO
    for region in @buildRegions()
      targetTraversal = targetTraversal.traverse(region.targetTraversal)
    targetTraversal
