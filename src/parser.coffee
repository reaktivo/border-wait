cheerio = require 'cheerio'
{ map, compact, flatten, extend } = require 'underscore'
tokens = require './tokens'
moment = require 'moment'

toInt = (number) -> parseInt(number || 0, 10)
contains = (str, needle) -> str.indexOf(needle) isnt -1;
$ = null

class BorderWaitParser

  tokens: tokens

  extract: (html) =>
    $ = cheerio.load html
    compact flatten map $('port'), @port

  port: (port) =>
    $port = $ port
    report = @report $port
    return if report.status is 'closed'
    map tokens.type, (typeSel, type) =>
      map tokens.lane, (laneSel, lane) =>
        $lane = $("#{typeSel} #{laneSel}", port)
        @lane $lane, extend {lane, type}, report

  lane: ($lane, report) =>
    return unless $lane.length
    status = $('operational_status', $lane).text()
    return unless contains status, 'delay'
    delay = @delay $('delay_minutes', $lane).text()
    return if delay is null
    time = @time report.updated_at, $('update_time', $lane).text()
    return if time is null or !time.isValid()
    updated_at = time.unix()
    updated_str = time.toString()
    extend {}, report, {updated_at, updated_str, delay}

  report: ($port) =>
    id: $('port_number', $port).text()
    port: $('port_name', $port).text()
    status: $('port_status', $port).text().toLowerCase()
    updated_at: $('date', $port).text()

  delay: (text) =>
    delay = tokens.delay.exec(text)
    if delay
      hours = toInt delay[1]
      minutes = toInt delay[2]
      hours * 60 + minutes
    else
      null

  time: (date, time) =>
    time = time
      .replace /PST/, '-0800'
      .replace /PDT|MST/, '-0700'
      .replace /CST|MDT/, '-0600'
      .replace /CDT|EST/, '-0500'
      .replace /EDT/, '-0400'
    timestr = date + time
    format = 'MM/DD/YYYY[At] hh:mm a ZZ'
    moment(timestr, format)

module.exports = new BorderWaitParser