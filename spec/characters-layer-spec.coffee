TextBuffer = require '../src/text-buffer'
Point = require '../src/point'

describe "characters layer", ->
  it "maps paired characters in the raw characters layer to single characters in the target", ->
    buffer = new TextBuffer(text: "a\uD835\uDF97b\uD835\uDF97c")
    charactersLayer = buffer.getCharactersLayer()

    expect(charactersLayer.characterAt(Point(0, 0))).toBe 'a'
    expect(charactersLayer.characterAt(Point(0, 1))).toBe '\uD835\uDF97'
    expect(charactersLayer.characterAt(Point(0, 2))).toBe 'b'
    expect(charactersLayer.characterAt(Point(0, 3))).toBe '\uD835\uDF97'
    expect(charactersLayer.characterAt(Point(0, 4))).toBe 'c'

  it "updates when the raw characters layer is updated", ->
    buffer = new TextBuffer(text: "a\uD835\uDF97b\uD835\uDF97c")
    rawCharactersLayer = buffer.getRawCharactersLayer()
    charactersLayer = buffer.getCharactersLayer()

    rawCharactersLayer.splice(Point.ZERO, Point.ZERO, 'x')

    expect(charactersLayer.characterAt(Point(0, 0))).toBe 'x'
    expect(charactersLayer.characterAt(Point(0, 1))).toBe 'a'
    expect(charactersLayer.characterAt(Point(0, 2))).toBe '\uD835\uDF97'
    expect(charactersLayer.characterAt(Point(0, 3))).toBe 'b'
    expect(charactersLayer.characterAt(Point(0, 4))).toBe '\uD835\uDF97'
    expect(charactersLayer.characterAt(Point(0, 5))).toBe 'c'

    rawCharactersLayer.splice(Point(0, 4), Point(0, 3), '\uD835\uDF97b')

    expect(charactersLayer.characterAt(Point(0, 0))).toBe 'x'
    expect(charactersLayer.characterAt(Point(0, 1))).toBe 'a'
    expect(charactersLayer.characterAt(Point(0, 2))).toBe '\uD835\uDF97'
    expect(charactersLayer.characterAt(Point(0, 3))).toBe '\uD835\uDF97'
    expect(charactersLayer.characterAt(Point(0, 4))).toBe 'b'
    expect(charactersLayer.characterAt(Point(0, 5))).toBe 'c'
