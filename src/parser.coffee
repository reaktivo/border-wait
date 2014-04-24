cheerio = require 'cheerio'
{ map, compact, flatten } = require 'underscore'
tokens = require './tokens'

toInt = (number) -> parseInt(number || 0, 10)

class BorderWaitParser

  reports: []
  tokens: tokens

  constructor: (text) ->
    @extract text if text

  extract: (text) ->
    $ = cheerio.load text
    text = $('item description').text()
    @reports = flatten map tokens.type, (token, type) =>
      typeText = token.exec(text)?[1]
      for lane in @lanes typeText
        lane.type = type
        lane
    @reports

  lanes: (text) ->
    compact map tokens.lane, (token, lane) =>
      matches = token.exec text
      if matches?.length
        delay = @delay matches[1]
        { lane, delay }

  delay: (text) ->
    return if text.indexOf("Update Pending") isnt -1
    text = text.replace 'no delay', '0 min'
    lane_info = tokens.delay.exec(text)
    if lane_info?.length
      hours = toInt lane_info[2]
      minutes = toInt lane_info[3]
      hours * 60 + minutes

module.exports = (text) ->
  new BorderWaitParser text