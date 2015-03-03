TextBuffer = require "../src/text-buffer"
Point = require "../src/point"

describe "soft tabs layer", ->
  [text, softTabsLayer, linesLayer] = []

  beforeEach ->
    text = "    hello  world ;)"
    buffer = new TextBuffer(text: text)
    linesLayer = buffer.getLinesLayer()
    softTabsLayer = buffer.buildSoftTabsLayer(2)

  describe "slicing", ->
    it "does not perform any text replacement", ->
      expect(softTabsLayer.slice(Point(0, 0), Point(1, 0))).toBe(text)

  describe "clipping", ->
    it "does not clip at non-leading whitespaces", ->
      expect(softTabsLayer.clipPosition(Point(0, 10))).toEqual Point(0, 10)
      expect(softTabsLayer.clipPosition(Point(0, 10), "backward")).toEqual Point(0, 10)
      expect(softTabsLayer.clipPosition(Point(0, 10), "forward")).toEqual Point(0, 10)

    it "does not clip at tab stops", ->
      expect(softTabsLayer.clipPosition(Point(0, 0))).toEqual Point(0, 0)
      expect(softTabsLayer.clipPosition(Point(0, 2))).toEqual Point(0, 2)
      expect(softTabsLayer.clipPosition(Point(0, 4))).toEqual Point(0, 4)

    it "does not clip at characters", ->
      expect(softTabsLayer.clipPosition(Point(0, 5))).toEqual Point(0, 5)
      expect(softTabsLayer.clipPosition(Point(0, 6))).toEqual Point(0, 6)

    it "clips between leading tab stops", ->
      expect(softTabsLayer.clipPosition(Point(0, 1))).toEqual Point(0, 0)
      expect(softTabsLayer.clipPosition(Point(0, 1), "backward")).toEqual Point(0, 0)
      expect(softTabsLayer.clipPosition(Point(0, 1), "forward")).toEqual Point(0, 2)
      expect(softTabsLayer.clipPosition(Point(0, 3))).toEqual Point(0, 2)
      expect(softTabsLayer.clipPosition(Point(0, 3), "backward")).toEqual Point(0, 2)
      expect(softTabsLayer.clipPosition(Point(0, 3), "forward")).toEqual Point(0, 4)

  describe "mapping", ->
    it "respects clip without altering alignment between from and to", ->
      mappings = [
        [[0, 0], [0, 0]]
        [[0, 0], [0, 1], clip: "backward"]
        [[0, 2], [0, 1], clip: "forward"]
        [[0, 2], [0, 2]]
        [[0, 2], [0, 3], clip: "backward"]
        [[0, 4], [0, 3], clip: "forward"]
        [[0, 4], [0, 4]]
        [[0, 5], [0, 5]],
        [[0, 10], [0, 10]]
      ]

      for [linesPoint, tabsPoint, options] in mappings
        unless options?
          expect(softTabsLayer.fromPositionInLayer(Point(linesPoint...), linesLayer)).toEqual Point(tabsPoint...)
        expect(softTabsLayer.toPositionInLayer(Point(tabsPoint...), linesLayer, options)).toEqual Point(linesPoint...)
