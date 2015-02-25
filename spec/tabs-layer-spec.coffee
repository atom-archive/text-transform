TextBuffer = require '../src/text-buffer'
Point = require '../src/point'

describe "tabs layer", ->
  it "replaces hard tab characters with whitespace", ->
    buffer = new TextBuffer(text: "\tab\tcde\tf")
    linesLayer = buffer.getLinesLayer()
    tabsLayer = buffer.buildTabsLayer(2)
    expect(tabsLayer.getContent()).toBe "  ab  cde f"

    mappings = [
      [[0, 0], [0, 0]]
      [[0, 0], [0, 1], clip: 'backward'] # one-way
      [[0, 1], [0, 1], clip: 'forward'] # one-way
      [[0, 1], [0, 2]]
      [[0, 2], [0, 3]]
      [[0, 3], [0, 4]]
      [[0, 3], [0, 5], clip: 'backward'] # one-way
      [[0, 4], [0, 5], clip: 'forward'] # one-way
      [[0, 4], [0, 6]]
      [[0, 5], [0, 7]]
      [[0, 6], [0, 8]]
      [[0, 7], [0, 9]]
      [[0, 8], [0, 10]]
      [[0, 9], [0, 11]]
    ]

    for [linesPoint, tabsPoint, options] in mappings
      unless options?
        expect(tabsLayer.fromPositionInLayer(Point(linesPoint...), linesLayer)).toEqual Point(tabsPoint...)
      expect(tabsLayer.toPositionInLayer(Point(tabsPoint...), linesLayer, options)).toEqual Point(linesPoint...)

    buffer = new TextBuffer(text: "\tab\ncde\n\tfg")
    linesLayer = buffer.getLinesLayer()
    tabsLayer = buffer.buildTabsLayer(2)
    expect(tabsLayer.getContent()).toBe "  ab\ncde\n  fg"

    mappings = [
      [[0, 0], [0, 0]]
      [[0, 0], [0, 1], clip: 'backward'] # one-way
      [[0, 1], [0, 1], clip: 'forward'] # one-way
      [[0, 1], [0, 2]]
      [[0, 2], [0, 3]]
      [[0, 3], [0, 4]]
      [[0, 4], [0, 5]]
      [[1, 0], [1, 0]]
      [[1, 1], [1, 1]]
      [[1, 2], [1, 2]]
      [[1, 3], [1, 3]]
      [[1, 4], [1, 4]]
      [[2, 0], [2, 0]]
      [[2, 0], [2, 1], clip: 'backward']
      [[2, 1], [2, 1], clip: 'forward']
      [[2, 1], [2, 2]]
      [[2, 2], [2, 3]]
      [[2, 3], [2, 4]]
    ]

    for [linesPoint, tabsPoint, options] in mappings
      unless options?
        expect(tabsLayer.fromPositionInLayer(Point(linesPoint...), linesLayer)).toEqual Point(tabsPoint...)
      expect(tabsLayer.toPositionInLayer(Point(tabsPoint...), linesLayer, options)).toEqual Point(linesPoint...)
