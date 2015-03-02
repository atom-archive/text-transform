Point = require './point'
Region = require './region'

module.exports =
class LinesTransform
  initialize: (@source) ->

  getNextRegions: ({sourceStartPosition}) ->
    [@getNextRegion({sourceStartPosition})]

  getNextRegion: ({sourceStartPosition}) ->
    if newlinePosition = @source.positionOf('\n', sourceStartPosition)
      sourceEndPosition = newlinePosition.traverse(Point(0, 1))
      sourceTraversal = sourceEndPosition.traversalFrom(sourceStartPosition)
      targetTraversal = Point(1, 0)
      new Region(sourceTraversal, targetTraversal)
    else
      traversal = @source.getEndPosition().traversalFrom(sourceStartPosition)
      new Region(traversal, traversal)

  getContent: ({sourceStartPosition, sourceEndPosition, targetStartPosition, targetEndPosition}) ->
    @source.slice(sourceStartPosition, sourceEndPosition).replace('\n', ' ')
