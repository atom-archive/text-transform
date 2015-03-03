Point = require './point'
Region = require './region'

module.exports =
class SoftWrapsTransform
  constructor: ({@baseCharacterWidth, @clientWidth}) ->

  initialize: (@source) ->

  getRegions: ({sourceStartPosition}) ->
    sourceLineEnd = @source.clipPosition(sourceStartPosition.traverse(Point(0, Infinity)))
    width = 0
    sourcePosition = sourceStartPosition

    while sourcePosition.isLessThan(sourceLineEnd)
      nextSourcePosition = @source.clipPosition(sourcePosition.traverse(Point(0, 1)), 'forward')
      width += @baseCharacterWidth

      if /\s/.test(@source.characterAt(sourcePosition))
        sourceEndPosition = nextSourcePosition
      else if width > @clientWidth
        targetTraversal = Point(1, 0)
        break

      sourcePosition = nextSourcePosition

    sourceEndPosition ?= sourcePosition
    sourceTraversal = sourceEndPosition.traversalFrom(sourceStartPosition)
    targetTraversal ?= sourceTraversal
    [new Region(sourceTraversal, targetTraversal)]

  getContent: ({sourceStartPosition, sourceEndPosition}) ->
    @source.slice(sourceStartPosition, sourceEndPosition)
