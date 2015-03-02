Point = require './point'
Region = require './region'
_ = require 'underscore-plus'

module.exports =
class SoftWrapsTransform
  constructor: ({@baseCharacterWidth, @clientWidth}) ->

  initialize: (@source) ->

  getNextRegions: ({sourceStartPosition}) ->
    regions = []
    sourceLineEnd = @source.clipPosition(sourceStartPosition.traverse(Point(0, Infinity)))
    width = 0
    sourcePosition = sourceStartPosition
    start = sourceStartPosition

    while sourcePosition.isLessThan(sourceLineEnd)
      nextSourcePosition = @source.clipPosition(sourcePosition.traverse(Point(0, 1)), 'forward')
      width += @baseCharacterWidth

      if /\s/.test(@source.characterAt(sourcePosition))
        sourceEndPosition = nextSourcePosition
      else if width > @clientWidth
        width = 0
        sourceTraversal = sourceEndPosition.traversalFrom(start)
        regions.push new Region(sourceTraversal, Point(1, 0))
        start = sourceEndPosition
        if @hasTabAt(sourceStartPosition)
          # TODO: replace "2" with the real indentation
          regions.push new Region(Point(0, 0), Point(0, 2), 'exclusive')
          width += @baseCharacterWidth * 2

      sourcePosition = nextSourcePosition

    sourceEndPosition ?= sourcePosition
    sourceTraversal = sourceEndPosition.traversalFrom(start)
    regions.push(new Region(sourceTraversal, sourceTraversal)) if regions.length == 0
    regions

  hasTabAt: (sourceStartPosition) ->
    tabPosition = @source.positionOf('\t', sourceStartPosition)
    return unless tabPosition

    tabPosition.isEqual(sourceStartPosition)

  getContent: ({sourceStartPosition, sourceEndPosition, targetStartPosition, targetEndPosition}) ->
    if sourceStartPosition.isEqual(sourceEndPosition)
      _.multiplyString(
        " ",
        targetEndPosition.traversalFrom(targetStartPosition).columns
      )
    else
      @source.slice(sourceStartPosition, sourceEndPosition)
