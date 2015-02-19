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

  getContent: ->
    content = ""
    for region in @getRegions()
      content += region.content
    content

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
        if start.isGreaterThan(targetTraversal)
          startIndex = pointToIndex(region.content, targetTraversal.traversal(start))
        else
          startIndex = 0

        index = region.content.indexOf(string, startIndex)
        if index >= 0
          return targetTraversal.traverse(indexToPoint(region.content, index))

      targetTraversal = nextTargetTraversal

    undefined

  slice: (start, end=@getEndPosition()) ->
    content = ""
    targetTraversal = Point.ZERO

    for region in @getRegions()
      nextTargetTraversal = targetTraversal.traverse(region.targetTraversal)
      if nextTargetTraversal.isGreaterThan(start)
        if start.isGreaterThan(targetTraversal)
          startIndex = pointToIndex(region.content, targetTraversal.traversal(start))
        else
          startIndex = 0

        if nextTargetTraversal.isGreaterThan(end)
          endIndex = pointToIndex(region.content, targetTraversal.traversal(end))
        else
          endIndex = undefined

        content += region.content.slice(startIndex, endIndex)

      targetTraversal = nextTargetTraversal

    content

  getEndPosition: ->
    targetTraversal = Point.ZERO
    for region in @getRegions()
      targetTraversal = targetTraversal.traverse(region.targetTraversal)
    targetTraversal

pointToIndex = (string, point) ->
  {rows, columns} = point
  index = 0

  loop
    if rows > 0
      newlineIndex = string.indexOf('\n', index)
      if newlineIndex >= 0
        index = newlineIndex
        rows--
      else
        throw new Error("Point #{point} out of range in string #{JSON.stringify(string)}")
    else
      index += columns
      if index <= string.length
        return index
      else
        throw new Error("Point #{point} out of range in string #{JSON.stringify(string)}")

indexToPoint = (string, index) ->
  rows = 0
  columns = 0

  if index > string.length
    throw new Error("Index #{index} out of range in string #{JSON.stringify(string)}")

  startIndex = 0
  loop
    newlineIndex = string.indexOf('\n', startIndex)
    if 0 <= newlineIndex <= index
      rows++
      columns = 0
      startIndex = newlineIndex + 1
    else
      columns = index - startIndex
      break

  Point(rows, columns)
