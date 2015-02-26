TextBuffer = require '../src/text-buffer'
Point = require '../src/point'

{expectValues} = require './spec-helper'

describe "lines layer", ->
  it "transforms the linear characters layer into a layer with regions for each line", ->
    buffer = new TextBuffer(text: "abc\ndefg\nhi")
    charactersLayer = buffer.getCharactersLayer()
    linesLayer = buffer.getLinesLayer()

    expect(linesLayer.slice(Point(0, 0), Point(1, 0))).toBe "abc "
    expect(linesLayer.slice(Point(1, 0), Point(2, 0))).toBe "defg "
    expect(linesLayer.slice(Point(2, 0), Point(2, 2))).toBe "hi"

    mappings = [
      [[0, 0], [0, 0]]
      [[0, 1], [0, 1]]
      [[0, 2], [0, 2]]
      [[0, 3], [0, 3]]
      [[0, 4], [1, 0]]
      [[0, 5], [1, 1]]
      [[0, 6], [1, 2]]
      [[0, 7], [1, 3]]
      [[0, 8], [1, 4]]
      [[0, 9], [2, 0]]
      [[0, 10], [2, 1]]
      [[0, 11], [2, 2]]
    ]

    for [charactersPoint, linesPoint] in mappings
      expect(linesLayer.fromPositionInLayer(Point(charactersPoint...), charactersLayer)).toEqual Point(linesPoint...)
      expect(linesLayer.toPositionInLayer(Point(linesPoint...), charactersLayer)).toEqual Point(charactersPoint...)

    expect(linesLayer.clipPosition(Point(-1, -1))).toEqual Point(0, 0)
    expect(linesLayer.clipPosition(Point(-1, 2))).toEqual Point(0, 2)
    expect(linesLayer.clipPosition(Point(1, -2))).toEqual Point(1, 0)
    expect(linesLayer.clipPosition(Point(1, 2))).toEqual Point(1, 2)
    expect(linesLayer.clipPosition(Point(1, 4))).toEqual Point(1, 4)
    expect(linesLayer.clipPosition(Point(1, 5))).toEqual Point(1, 4)
    expect(linesLayer.clipPosition(Point(1, 5), 'forward')).toEqual Point(2, 0)
    expect(linesLayer.clipPosition(Point(3, 0))).toEqual Point(2, 2)
