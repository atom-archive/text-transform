TextBuffer = require '../src/text-buffer'
Point = require '../src/point'

describe "soft wraps layer", ->
  it "carries indentation on soft-wrapped lines", ->
    buffer = new TextBuffer(text: '\tabc def ghi jklmnopqr')
    linesLayer = buffer.getLinesLayer()
    softWrapsLayer = buffer.buildSoftWrapsLayer(baseCharacterWidth: 10, clientWidth: 100, tabLength: 2)
    expect(softWrapsLayer.slice(Point(0, 0), Point(1, 0))).toBe "  abc def "
    expect(softWrapsLayer.slice(Point(1, 0), Point(2, 0))).toBe "  ghi "
    expect(softWrapsLayer.slice(Point(2, 0), Point(3, 0))).toBe "  jklmnopqr"

    mappings = [
      [[0, 0], [0, 0]]
      [[0, 7], [0, 8]]
      [[0, 9], [1, 2]]
      [[0, 12], [1, 5]]
      [[0, 13], [2, 2]]
      [[0, 14], [2, 3]]
    ]

    for [linesPoint, softWrapsPoint, options] in mappings
      unless options?
        expect(softWrapsLayer.fromPositionInLayer(Point(linesPoint...), linesLayer)).toEqual Point(softWrapsPoint...)
      expect(softWrapsLayer.toPositionInLayer(Point(softWrapsPoint...), linesLayer, options)).toEqual Point(linesPoint...)

    expect(softWrapsLayer.clipPosition(Point(1, 6), 'backward')).toEqual Point(1, 5)
    expect(softWrapsLayer.clipPosition(Point(1, 6), 'forward')).toEqual Point(2, 2)

  it "soft-wraps lines based on line length, ::baseCharacterWidth, and ::contentFrameWidth", ->
    buffer = new TextBuffer(text: 'abc def ghi jklmno\tpqr')
    linesLayer = buffer.getLinesLayer()
    softWrapsLayer = buffer.buildSoftWrapsLayer(baseCharacterWidth: 10, clientWidth: 100, tabLength: 2)
    expect(softWrapsLayer.slice(Point(0, 0), Point(1, 0))).toBe "abc def "
    expect(softWrapsLayer.slice(Point(1, 0), Point(2, 0))).toBe "ghi jklmno  "
    expect(softWrapsLayer.slice(Point(2, 0), Point(3, 0))).toBe "pqr"

    mappings = [
      [[0, 0], [0, 0]]
      [[0, 7], [0, 7]]
      [[0, 8], [1, 0]]
      [[0, 9], [1, 1]]
      [[0, 17], [1, 9]]
      [[0, 18], [1, 10]]
      [[0, 18], [1, 11], clip: 'backward']
      [[0, 19], [1, 11], clip: 'forward']
      [[0, 19], [2, 0]]
      [[0, 20], [2, 1]]
      [[0, 22], [2, 3]]
    ]

    for [linesPoint, softWrapsPoint, options] in mappings
      unless options?
        expect(softWrapsLayer.fromPositionInLayer(Point(linesPoint...), linesLayer)).toEqual Point(softWrapsPoint...)
      expect(softWrapsLayer.toPositionInLayer(Point(softWrapsPoint...), linesLayer, options)).toEqual Point(linesPoint...)

    expect(softWrapsLayer.clipPosition(Point(1, 11), 'backward')).toEqual Point(1, 10)
    expect(softWrapsLayer.clipPosition(Point(1, 11), 'forward')).toEqual Point(2, 0)
