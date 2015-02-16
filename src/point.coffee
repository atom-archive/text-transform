module.exports =
class Point
  @ZERO = new Point(0, 0)

  constructor: (rows, columns) ->
    if this instanceof Point
      @rows = rows
      @columns = columns
    else
      return new Point(rows, columns)

  traverse: (delta) ->
    if delta.rows > 0
      new Point(@rows + delta.rows, delta.columns)
    else
      new Point(@rows, @columns + delta.columns)

  isGreaterThan: (other) ->
    @compare(other) > 0

  compare: (other) ->
    if @rows > other.rows
      1
    else if @rows < other.rows
      -1
    else
      if @columns < other.columns
        -1
      else if @columns > other.columns
        1
      else
        0

  toString: ->
    "(#{@rows}, #{@columns})"
