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

    targetStartPosition = Point.ZERO
    sourceStartPosition = Point.ZERO

    for region in @regions
      break if targetStartPosition.compare(end) >= 0

      nextTargetStartPosition = targetStartPosition.traverse(region.targetTraversal)
      nextSourceStartPosition = sourceStartPosition.traverse(region.sourceTraversal)

      if nextTargetStartPosition.isGreaterThan(start)
        contentStart ?= targetStartPosition
        contentEnd = nextTargetStartPosition
        content += @transform.contentForRegion({region, sourceStartPosition, targetStartPosition})

      targetStartPosition = nextTargetStartPosition
      sourceStartPosition = nextSourceStartPosition

    contentStartIndex = 0
    if contentStart?
      {rows, columns} = contentStart.traversal(start)
      while rows > 0
        contentStartIndex = content.indexOf('\n', contentStartIndex) + 1
        rows--
      contentStartIndex += columns

    contentEndIndex = content.length
    if contentEnd?
      contentEndIndex = contentStartIndex
      {rows, columns} = start.traversal(end)
      while rows > 0
        contentEndIndex = content.indexOf('\n', contentEndIndex) + 1
        rows--
      contentEndIndex += columns


    content = content.slice(contentStartIndex, contentEndIndex)
    content

  getEndPosition: ->
    targetTraversal = Point.ZERO
    for region in @regions
      targetTraversal = targetTraversal.traverse(region.targetTraversal)
    targetTraversal
