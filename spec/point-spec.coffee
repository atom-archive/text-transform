Point = require '../src/point'

describe "Point", ->
  describe "::traversalFrom", ->
    it "returns the traversal distance from the given point", ->
      pointPairs = [
        [Point(0, 0), Point(0, 5)]
        [Point(0, 0), Point(5, 0)]
        [Point(2, 3), Point(6, 7)]
      ]

      for [a, b] in pointPairs
        expect(b.traverse(a.traversalFrom(b))).toEqual a
        expect(a.traverse(b.traversalFrom(a))).toEqual b
