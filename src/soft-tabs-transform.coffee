Point = require './point'
Region = require './region'

module.exports =
class SoftTabsTransform
  constructor: (@tabLength) ->
    @softTab = " ".repeat(@tabLength)

  initialize: (@source) ->

  getNextRegion: ({sourceStartPosition}) ->
    sourceEndPosition = @source.getEndPosition()

    if @source.startsWith(@softTab, sourceStartPosition)
      softTabTraversal = Point(0, @tabLength)
      new Region(softTabTraversal, softTabTraversal, 'exclusive')
    else
      nextLinePosition = sourceStartPosition.traverse(Point(1, 0))
      nextLineTraversal = nextLinePosition.traversalFrom(sourceStartPosition)
      new Region(nextLineTraversal, nextLineTraversal)

  getContent: ({sourceStartPosition, sourceEndPosition}) ->
    @source.slice(sourceStartPosition, sourceEndPosition)
