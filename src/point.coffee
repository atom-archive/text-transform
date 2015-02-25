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

  traversal: (other) ->
    if @compare(other) > 0
      throw new Error("Traversal from #{this} to #{other} invalid. Must traverse forward for now.")

    if other.rows > @rows
      new Point(other.rows - @rows, other.columns)
    else
      new Point(0, other.columns - @columns)

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
