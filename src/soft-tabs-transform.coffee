Point = require './point'
Region = require './region'
_ = require 'underscore-plus'

module.exports =
class SoftTabsTransform
  constructor: (@tabLength) ->
    @tab = _.multiplyString(" ", @tabLength)

  initialize: (@source) ->

  getNextRegion: ({sourceStartPosition, targetStartPosition}) ->
    if @hasTabStopAt(sourceStartPosition)
      new Region(Point(0, @tabLength), Point(0, @tabLength), 'exclusive')
    else
      traversal = @source.getEndPosition().traversalFrom(sourceStartPosition)
      new Region(traversal, traversal)

  hasTabStopAt: (position) ->
    tabStop = @source.positionOf(@tab, position)
    tabStop?.isEqual(position)

  getContent: ({sourceStartPosition, sourceEndPosition, targetStartPosition, targetEndPosition}) ->
    @source.slice(sourceStartPosition, sourceEndPosition)
