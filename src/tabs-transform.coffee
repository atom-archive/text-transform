Point = require './point'
Region = require './region'

module.exports =
class TabsTransform
  constructor: (@tabLength) ->

  initialize: (@source) ->

  getNextRegion: ({sourceStartPosition, targetStartPosition}) ->
    if tabPosition = @source.positionOf('\t', sourceStartPosition)
      if tabPosition.isEqual(sourceStartPosition)
        tabLength = targetStartPosition.columns % @tabLength
        tabLength = @tabLength if tabLength is 0
        content = ''
        content += ' ' for i in [0...tabLength] by 1
        new Region(Point(0, 1), Point(0, tabLength), content)
      else
        content = @source.slice(sourceStartPosition, tabPosition)
        traversal = sourceStartPosition.traversal(tabPosition)
        new Region(traversal, traversal, content)
    else
      content = @source.slice(sourceStartPosition)
      traversal = sourceStartPosition.traversal(@source.getEndPosition())
      new Region(traversal, traversal, content)
