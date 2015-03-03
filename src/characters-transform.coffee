Point = require './point'
Region = require './region'
isPairedCharacter = require './is-paired-character'

module.exports =
class CharactersTransform
  initialize: (@source) ->

  getRegions: ({sourceStartPosition}) ->
    sourcePosition = sourceStartPosition
    maxSourcePosition = @source.getEndPosition()

    while sourcePosition.isLessThan(maxSourcePosition)
      charCode1 = @source.charCodeAtPosition(sourcePosition)
      charCode2 = @source.charCodeAtPosition(sourcePosition.traverse(Point(0, 1)))

      if isPairedCharacter(charCode1, charCode2)
        if sourcePosition.isEqual(sourceStartPosition)
          return [new Region(Point(0, 2), Point(0, 1))]
        else
          break
      else
        sourcePosition = sourcePosition.traverse(Point(0, 1))

    traversal = sourcePosition.traversalFrom(sourceStartPosition)
    [new Region(traversal, traversal)]

  getContent: ({sourceStartPosition, sourceEndPosition}) ->
    @source.slice(sourceStartPosition, sourceEndPosition)
