Point = require './point'

module.exports =
class Layer
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
      targetStartPosition = targetStartPosition.traverse(region.targetTraversal)
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

  positionOf: (string, start=Point(0, 0)) ->
    targetTraversal = Point.ZERO

    for region in @getRegions()
      nextTargetTraversal = targetTraversal.traverse(region.targetTraversal)
      if nextTargetTraversal.isGreaterThan(start)
        if targetTraversal.isGreaterThan(start)
          contentStartIndex = 0
        else
          contentStartIndex = start.columns - targetTraversal.columns

        contentIndex = region.content.indexOf(string, contentStartIndex)
        if contentIndex >= 0
          return targetTraversal.traverse(Point(0, contentIndex))

      targetTraversal = nextTargetTraversal

    undefined

  slice: (start, end=@getEndPosition()) ->
    content = ""
    targetTraversal = Point.ZERO

    for region in @getRegions()
      nextTargetTraversal = targetTraversal.traverse(region.targetTraversal)
      if nextTargetTraversal.isGreaterThan(start)
        if targetTraversal.isGreaterThan(start)
          contentStartIndex = 0
        else
          contentStartIndex = start.columns - targetTraversal.columns

        if nextTargetTraversal.isGreaterThan(end)
          contentEndIndex = end.columns - targetTraversal.columns
        else
          contentEndIndex = undefined

        content += region.content.slice(contentStartIndex, contentEndIndex)

    content

  getEndPosition: ->
    targetTraversal = Point.ZERO
    for region in @getRegions()
      targetTraversal = targetTraversal.traverse(region.targetTraversal)
    targetTraversal
