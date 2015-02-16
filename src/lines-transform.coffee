Point = require './point'
Region = require './region'

module.exports =
class LinesTransform
  setSource: (@source) ->

  getNextRegion: ({sourceStartPosition}) ->
    if newlinePosition = @source.positionOf('\n', sourceStartPosition)
      sourceRegion = @source.slice(sourceStartPosition, newlinePosition.traverse(Point(0, 1)))
      new Region(sourceRegion.sourceTraversal, Point(1, 0), sourceRegion.content)
    else
      @source.slice(sourceStartPosition)
