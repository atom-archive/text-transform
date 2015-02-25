TextBuffer = require '../src/text-buffer'
Point = require '../src/point'

{expectValues} = require './spec-helper'

describe "lines layer", ->
  it "transforms the linear characters layer into a layer with regions for each line", ->
    buffer = new TextBuffer(text: "abc\ndefg\nhi")
    charactersLayer = buffer.getCharactersLayer()
    linesLayer = buffer.getLinesLayer()

    expect(linesLayer.getContent()).toBe """
      abc
      defg
      hi
    """

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
