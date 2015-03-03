require 'coffee-cache'
Point = require '../src/point'

exports.expectValues = (actual, expected) ->
  for expectedKey, expectedValue of expected
    expect(actual[expectedKey]).toEqual expectedValue

exports.expectMapping = (mappings, layer, upperLayer) ->
  for [linesPoint, tabsPoint, options] in mappings
    unless options?
      expect(layer.fromPositionInLayer(Point(linesPoint...), upperLayer)).toEqual Point(tabsPoint...)
    expect(layer.toPositionInLayer(Point(tabsPoint...), upperLayer, options)).toEqual Point(linesPoint...)
