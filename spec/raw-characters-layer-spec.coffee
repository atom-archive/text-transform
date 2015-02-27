RawCharactersLayer = require '../src/raw-characters-layer'
Point = require '../src/point'

describe "RawCharactersLayer", ->
  describe "::splice(start, extent, text)", ->
    it "inserts the given text at the given position", ->
      layer = new RawCharactersLayer("abcdef")
      layer.splice(Point(0, 3), Point.ZERO, "xyz")
      expect(layer.slice()).toBe "abcxyzdef"

      layer.splice(Point(0, 4), Point(0, 1), "abc")
      expect(layer.slice()).toBe "abcxabczdef"
