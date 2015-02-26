Point = require './point'
Region = require './region'

module.exports =
class LinesTransform
  initialize: (@source) ->

  getNextRegion: ({sourceStartPosition}) ->
    if newlinePosition = @source.positionOf('\n', sourceStartPosition)
      sourceEndPosition = newlinePosition.traverse(Point(0, 1))
      sourceTraversal = sourceStartPosition.traversal(sourceEndPosition)
      targetTraversal = Point(1, 0)
      new Region(sourceTraversal, targetTraversal)
    else
      traversal = sourceStartPosition.traversal(@source.getEndPosition())
      new Region(traversal, traversal)

  getContent: ({sourceStartPosition, sourceEndPosition, targetStartPosition, targetEndPosition}) ->
    @source.slice(sourceStartPosition, sourceEndPosition).replace('\n', ' ')
