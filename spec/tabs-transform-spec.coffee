TextBuffer = require '../src/text-buffer'

describe "TabsTransform", ->
  it "replaces hard tab characters with whitespace", ->
    buffer = new TextBuffer(text: "\tab\tcde\tf")
    tabsLayer = buffer.buildTabsLayer(2)
    expect(tabsLayer.regions.map (r) -> r.toString()).toEqual [
      '<(0, 1):(0, 2) - "  ">'
      '<(0, 2):(0, 2) - "ab">'
      '<(0, 1):(0, 2) - "  ">'
      '<(0, 3):(0, 3) - "cde">'
      '<(0, 1):(0, 1) - " ">'
      '<(0, 1):(0, 1) - "f">'
    ]

    buffer = new TextBuffer(text: "\tab\ncde\n\tfg")
    tabsLayer = buffer.buildTabsLayer(2)
    expect(tabsLayer.regions.map (r) -> r.toString()).toEqual [
      '<(0, 1):(0, 2) - "  ">'
      '<(2, 0):(2, 0) - "ab\\ncde\\n">'
      '<(0, 1):(0, 2) - "  ">'
      '<(0, 2):(0, 2) - "fg">'
    ]
