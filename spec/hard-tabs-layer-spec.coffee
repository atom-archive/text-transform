TextBuffer = require '../src/text-buffer'
Point = require '../src/point'

describe "hard tabs layer", ->
  it "replaces hard tab characters with whitespace", ->
    buffer = new TextBuffer(text: "\tab\tcde\tf")
    linesLayer = buffer.getLinesLayer()
    tabsLayer = buffer.buildHardTabsLayer(2)
    expect(tabsLayer.slice(Point(0, 0), Point(1, 0))).toBe "  ab  cde f"

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

    expectMapping(mappings, tabsLayer, linesLayer)

    expect(tabsLayer.clipPosition(Point(0, 0), 'forward')).toEqual Point(0, 0)
    expect(tabsLayer.clipPosition(Point(0, 1), 'backward')).toEqual Point(0, 0)
    expect(tabsLayer.clipPosition(Point(0, 1), 'forward')).toEqual Point(0, 2)

    buffer = new TextBuffer(text: "\tab\ncd\t\n\tfg")
    linesLayer = buffer.getLinesLayer()
    tabsLayer = buffer.buildHardTabsLayer(2)

    expect(tabsLayer.slice(Point(0, 0), Point(1, 0))).toBe "  ab "
    expect(tabsLayer.slice(Point(1, 0), Point(2, 0))).toBe "cd   "
    expect(tabsLayer.slice(Point(2, 0), Point(3, 0))).toBe "  fg"

    mappings = [
      [[0, 0], [0, 0]]
      [[0, 0], [0, 1], clip: 'backward']
      [[0, 1], [0, 1], clip: 'forward']
      [[0, 1], [0, 2]]
      [[0, 2], [0, 3]]
      [[0, 3], [0, 4]]
      [[0, 3], [0, 5], clip: 'backward']
      [[1, 0], [0, 5], clip: 'forward']
      [[1, 0], [1, 0]]
      [[1, 1], [1, 1]]
      [[1, 2], [1, 2]]
      [[1, 2], [1, 3], clip: 'backward']
      [[1, 3], [1, 3], clip: 'forward']
      [[1, 3], [1, 4]]
      [[2, 0], [2, 0]]
      [[2, 0], [2, 1], clip: 'backward']
      [[2, 1], [2, 1], clip: 'forward']
      [[2, 1], [2, 2]]
      [[2, 2], [2, 3]]
      [[2, 3], [2, 4]]
    ]

    expectMapping(mappings, tabsLayer, linesLayer)

    expect(tabsLayer.clipPosition(Point(1, 3), 'backward')).toEqual Point(1, 2)
    expect(tabsLayer.clipPosition(Point(1, 3), 'forward')).toEqual Point(1, 4)
    expect(tabsLayer.clipPosition(Point(1, 4), 'backward')).toEqual Point(1, 4)
    expect(tabsLayer.clipPosition(Point(1, 5), 'forward')).toEqual Point(2, 0)
