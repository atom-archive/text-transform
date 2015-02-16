module.exports =
class Region
  constructor: (@sourceTraversal, @targetTraversal, @content) ->

  toString: ->
    "<#{@sourceTraversal}:#{@targetTraversal} - #{JSON.stringify(@content)}>"
