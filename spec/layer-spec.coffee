TextBuffer = require '../src/text-buffer'
Point = require '../src/point'

describe "Layer", ->
  describe "::positionOf(string, startIndex)", ->
    it "returns the position of the first match after the given startIndex or undefined if none exists", ->
      buffer = new TextBuffer(text: "abc\ndefg\nhia")
      linesLayer = buffer.getLinesLayer()

      expect(linesLayer.positionOf('a')).toEqual Point(0, 0)
      expect(linesLayer.positionOf('b')).toEqual Point(0, 1)
      expect(linesLayer.positionOf('d')).toEqual Point(1, 0)
      expect(linesLayer.positionOf('e')).toEqual Point(1, 1)
      expect(linesLayer.positionOf('a', Point(0, 1))).toEqual Point(2, 2)

      buffer = new TextBuffer(text: "\tab\ncbd\n\tef")
      tabsLayer = buffer.buildHardTabsLayer(2)

      expect(tabsLayer.positionOf('a')).toEqual Point(0, 2)
      expect(tabsLayer.positionOf('b')).toEqual Point(0, 3)
      expect(tabsLayer.positionOf('c')).toEqual Point(1, 0)

  describe "::startsWith(string, startIndex)", ->
    [buffer, linesLayer] = []

    beforeEach ->
      buffer = new TextBuffer(text: "abc\ndefg\nhia")
      linesLayer = buffer.getLinesLayer()

    describe "given a starting Point", ->
      it "is false when string is not present", ->
        expect(linesLayer.startsWith("z", Point(0, 0))).toBeFalsy()
        expect(linesLayer.startsWith("a", Point(0, 1))).toBeFalsy()
        expect(linesLayer.startsWith("h", Point(1, 0))).toBeFalsy()
        expect(linesLayer.startsWith("defg", Point(0, 0))).toBeFalsy()
        expect(linesLayer.startsWith("abcd", Point(0, 0))).toBeFalsy()

      it "is true when string can be matched", ->
        expect(linesLayer.startsWith("a", Point(0, 0))).toBeTruthy()
        expect(linesLayer.startsWith("b", Point(0, 1))).toBeTruthy()
        expect(linesLayer.startsWith("abc", Point(0, 0))).toBeTruthy()
        expect(linesLayer.startsWith("def", Point(1, 0))).toBeTruthy()
