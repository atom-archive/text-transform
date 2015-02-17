TextBuffer = require '../src/text-buffer'
Point = require '../src/point'

{expectValues} = require './spec-helper'

describe "LinesTransform", ->
  ffit "transforms the linear characters layer into a layer with regions for each line", ->
    buffer = new TextBuffer(text: "abc\ndefg\nhi")
    {charactersLayer, linesLayer} = buffer

    regions = linesLayer.getRegions()
    expect(regions.length).toBe 3
    expect(regions[0].toString()).toBe '<(0, 4):(1, 0) - "abc\\n">'
    expect(regions[1].toString()).toBe '<(0, 5):(1, 0) - "defg\\n">'
    expect(regions[2].toString()).toBe '<(0, 2):(0, 2) - "hi">'

    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 0))).toEqual Point(0, 0)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 1))).toEqual Point(0, 1)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 2))).toEqual Point(0, 2)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 3))).toEqual Point(0, 3)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 4))).toEqual Point(1, 0)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 5))).toEqual Point(1, 1)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 6))).toEqual Point(1, 2)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 7))).toEqual Point(1, 3)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 8))).toEqual Point(1, 4)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 9))).toEqual Point(2, 0)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 10))).toEqual Point(2, 1)
    expect(linesLayer.fromLayerPosition(charactersLayer, Point(0, 11))).toEqual Point(2, 2)
