require 'coffee-cache'

exports.expectValues = (actual, expected) ->
  for expectedKey, expectedValue of expected
    expect(actual[expectedKey]).toEqual expectedValue
