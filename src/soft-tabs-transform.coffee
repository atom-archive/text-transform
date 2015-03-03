require('es6-shim')

Point = require './point'
Region = require './region'

module.exports =
class SoftTabsTransform
  constructor: (@tabLength) ->
    @softTab = " ".repeat(@tabLength)

  initialize: (@source) ->

  getNextRegions: ({sourceStartPosition, sourceEndPosition, targetStartPosition}) ->
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
        traversal = @source.getEndPosition().traversalFrom(sourcePosition)
        regions.push(new Region(traversal, traversal))
        break

    regions

  hasTabStopAt: (position) ->
    tabStop = @source.positionOf(@softTab, position)
    tabStop?.isEqual(position)

  getContent: ({sourceStartPosition, sourceEndPosition, targetStartPosition, targetEndPosition}) ->
    @source.slice(sourceStartPosition, sourceEndPosition)
