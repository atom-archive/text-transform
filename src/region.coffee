module.exports =
class Region
  constructor: (@sourceTraversal, @targetTraversal, @clip) ->

  toString: ->
    "<#{@sourceTraversal}:#{@targetTraversal}>"
