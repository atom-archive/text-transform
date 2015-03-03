require 'coffee-cache'
Point = require '../src/point'

exports.expectValues = (actual, expected) ->
  for expectedKey, expectedValue of expected
    expect(actual[expectedKey]).toEqual expectedValue

exports.expectMappings = (mappings, {fromLayer, toLayer}) ->
  for [linesPoint, tabsPoint, options] in mappings
    unless options?
      expect(toLayer.fromPositionInLayer(Point(linesPoint...), fromLayer)).toEqual Point(tabsPoint...)
    expect(toLayer.toPositionInLayer(Point(tabsPoint...), fromLayer, options)).toEqual Point(linesPoint...)
