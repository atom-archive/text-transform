isPairedCharacter = require '../src/is-paired-character'

describe "isPairedCharacter(string, index)", ->
  it 'returns true when the index is the start of a high/low surrogate pair, variation sequence, or combined character', ->
    expect(isPairedCharacter('e'.charCodeAt(0), 'f'.charCodeAt(0))).toBe false

    expect(isPairedCharacter(0xD835, 0xDF97)).toBe true
    expect(isPairedCharacter(0xDF97, 'b'.charCodeAt(0))).toBe false

    expect(isPairedCharacter(0x2714, 0xFE0E)).toBe true
    expect(isPairedCharacter('a'.charCodeAt(0), 0x2714)).toBe false

    expect(isPairedCharacter('e'.charCodeAt(0), 0x0301)).toBe true
