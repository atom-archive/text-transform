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
    if delta.rows is 0
      new Point(@rows, @columns + delta.columns)
    else
      new Point(@rows + delta.rows, delta.columns)

  traversalFrom: (other) ->
    if @rows is other.rows
      new Point(0, @columns - other.columns)
    else
      new Point(@rows - other.rows, @columns)

  isEqual: (other) ->
    @rows is other.rows and @columns is other.columns

  isGreaterThan: (other) ->
    @compare(other) > 0

  isLessThan: (other) ->
    @compare(other) < 0

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
