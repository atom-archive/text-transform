Point = require './point'
Region = require './region'

module.exports =
class CharactersLayer
  constructor: (@content) ->

  positionOf: (string, start=Point(0, 0)) ->
    @assertPointInRange(start)

    columns = @content.indexOf(string, start.columns)
    if columns >= 0
      Point(0, columns)

  slice: (start, end) ->
    @assertPointInRange(start)
    @assertPointInRange(end) if end?
    @content.slice(start.columns, end?.columns)

  assertPointInRange: (point) ->
    unless point.rows is 0 and 0 <= point.columns <= @content.length
      throw new Error("Point #{point} out of range")

  sourceToTarget: (point) -> point

  getEndPosition: -> Point(0, @content.length)
