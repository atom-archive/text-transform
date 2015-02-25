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
    @slice(Point.ZERO, @getEndPosition())

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

  toPositionInLayer: (position, layer, options) ->
    targetPosition = position

    sourceTraversal = Point.ZERO
    targetTraversal = Point.ZERO

    for region in @regions
      nextTargetTraversal = targetTraversal.traverse(region.targetTraversal)
      nextSourceTraversal = sourceTraversal.traverse(region.sourceTraversal)
      break if nextTargetTraversal.isGreaterThan(targetPosition)
      targetTraversal = nextTargetTraversal
      sourceTraversal = nextSourceTraversal

    if region.clip
      if options?.clip is 'forward'
        sourcePosition = nextSourceTraversal
      else
        sourcePosition = sourceTraversal
    else
      overshoot = targetTraversal.traversal(targetPosition)
      sourcePosition = sourceTraversal.traverse(overshoot)

    if @source isnt layer
      @source.toPositionInLayer(sourcePosition, layer)
    else
      sourcePosition

  positionOf: (string, start=Point(0, 0)) ->
    if sourcePosition = @source.positionOf(string, @toPositionInLayer(start, @source))
      pos =  @fromPositionInLayer(sourcePosition, @source)
      return pos

  characterAt: (position) ->
    @slice(position, position.traverse(Point(0, 1)))

  slice: (start, end=@getEndPosition()) ->
    debugger if global.debug
    contentStart = null
    contentEnd = null
    content = ""

    targetTraversal = Point.ZERO
    sourceTraversal = Point.ZERO

    for region in @regions
      break if targetTraversal.compare(end) >= 0

      nextTargetTraversal = targetTraversal.traverse(region.targetTraversal)
      nextSourceTraversal = sourceTraversal.traverse(region.sourceTraversal)

      if nextTargetTraversal.isGreaterThan(start)
        if start.isGreaterThan(targetTraversal)
          targetStartPosition = start
          sourceStartPosition = sourceTraversal.traverse(targetTraversal.traversal(start))
        else
          targetStartPosition = targetTraversal
          sourceStartPosition = sourceTraversal

        if end.isLessThan(nextTargetTraversal)
          targetEndPosition = end
          sourceEndPosition = sourceTraversal.traverse(targetTraversal.traversal(end))
        else
          targetEndPosition = nextTargetTraversal
          sourceEndPosition = nextSourceTraversal

        content += @transform.getContent({sourceStartPosition, targetStartPosition, sourceEndPosition, targetEndPosition})

      targetTraversal = nextTargetTraversal
      sourceTraversal = nextSourceTraversal

    content

  getEndPosition: ->
    targetTraversal = Point.ZERO
    for region in @regions
      targetTraversal = targetTraversal.traverse(region.targetTraversal)
    targetTraversal
