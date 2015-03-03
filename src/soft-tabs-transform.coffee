require('es6-shim')

Point = require './point'
Region = require './region'

module.exports =
class SoftTabsTransform
  constructor: (@tabLength) ->
    @softTab = " ".repeat(@tabLength)

  initialize: (@source) ->

  getRegions: ({sourceStartPosition}) ->
    sourceEndPosition = @source.getEndPosition()
    sourcePosition = sourceStartPosition
    regions = []

    while sourcePosition.isLessThan(sourceEndPosition)
      if @hasTabStopAt(sourcePosition)
        softTabTraversal = Point(0, @tabLength)
        regions.push(
          new Region(softTabTraversal, softTabTraversal, 'exclusive')
        )
        sourcePosition = sourcePosition.traverse(softTabTraversal)
      else
        nextLinePosition = sourcePosition.traverse(Point(1, 0))
        nextLineTraversal = nextLinePosition.traversalFrom(sourcePosition)
        regions.push(new Region(nextLineTraversal, nextLineTraversal))
        sourcePosition = sourcePosition.traverse(nextLineTraversal)

    regions

  hasTabStopAt: (position) ->
    tabStop = @source.positionOf(@softTab, position)
    tabStop?.isEqual(position)

  getContent: ({sourceStartPosition, sourceEndPosition}) ->
    @source.slice(sourceStartPosition, sourceEndPosition)
