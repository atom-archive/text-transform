TextBuffer = require '../src/text-buffer'
Point = require '../src/point'

describe "characters layer", ->
  it "maps paired characters in the source to single characters in the target", ->
    buffer = new TextBuffer(text: "a\uD835\uDF97b\uD835\uDF97c")
    charactersLayer = buffer.getCharactersLayer()

    expect(charactersLayer.characterAt(Point(0, 0))).toBe 'a'
    expect(charactersLayer.characterAt(Point(0, 1))).toBe '\uD835\uDF97'
    expect(charactersLayer.characterAt(Point(0, 2))).toBe 'b'
    expect(charactersLayer.characterAt(Point(0, 3))).toBe '\uD835\uDF97'
    expect(charactersLayer.characterAt(Point(0, 4))).toBe 'c'
