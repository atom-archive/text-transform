{Emitter} = require 'event-kit'
Point = require './point'
Region = require './region'

module.exports =
class RawCharactersLayer
  constructor: (@content) ->
    @emitter = new Emitter

  onDidChange: (fn) ->
    @emitter.on 'did-change', fn

  positionOf: (string, start=Point(0, 0)) ->
    @assertPointInRange(start)

    columns = @content.indexOf(string, start.columns)
    if columns >= 0
      Point(0, columns)

  splice: (startPosition, oldExtent, newText) ->
    endPosition = startPosition.traverse(oldExtent)
    @assertPointInRange(startPosition)
    @assertPointInRange(endPosition)
    @content = @content.slice(0, startPosition.columns) + newText + @content.slice(endPosition.columns)
    newExtent = new Point(0, newText.length)
    @emitter.emit 'did-change', {startPosition, oldExtent, newExtent, newText}

  slice: (start, end) ->
    @assertPointInRange(start) if start?
    @assertPointInRange(end) if end?
    @content.slice(start?.columns, end?.columns)

  assertPointInRange: (point) ->
    unless point.rows is 0 and 0 <= point.columns <= @content.length
      throw new Error("Point #{point} out of range")

  sourceToTarget: (position) -> position

  clipPosition: (position) ->
    {rows, columns} = position
    rows = Math.max(0, rows)
    columns = Math.max(0, columns)
    if rows > 0
      rows = 0
      columns = Infinity
    columns = Math.min(@content.length, columns)
    Point(rows, columns)

  getEndPosition: -> Point(0, @content.length)

  charCodeAtPosition: (position) ->
    @assertPointInRange(position)
    @content.charCodeAt(position.columns)
