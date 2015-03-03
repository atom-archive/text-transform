Point = require './point'
Region = require './region'

module.exports =
class HardTabsTransform
  constructor: (@tabLength) ->

  initialize: (@source) ->

  getRegions: ({sourceStartPosition, targetStartPosition}) ->
    [@getNextRegion({sourceStartPosition, targetStartPosition})]

  getNextRegion: ({sourceStartPosition, targetStartPosition}) ->
    if tabPosition = @source.positionOf('\t', sourceStartPosition)
      if tabPosition.isEqual(sourceStartPosition)
        tabLength = targetStartPosition.columns % @tabLength
        tabLength = @tabLength if tabLength is 0
        new Region(Point(0, 1), Point(0, tabLength), 'exclusive')
      else
        traversal = tabPosition.traversalFrom(sourceStartPosition)
        new Region(traversal, traversal)
    else
      traversal = @source.getEndPosition().traversalFrom(sourceStartPosition)
      new Region(traversal, traversal)

  getContent: ({sourceStartPosition, sourceEndPosition, targetStartPosition, targetEndPosition}) ->
    if @source.characterAt(sourceStartPosition) is '\t'
      length = targetEndPosition.columns - targetStartPosition.columns
      content = ""
      content += " " for i in [0...length] by 1
      content
    else
      @source.slice(sourceStartPosition, sourceEndPosition)
