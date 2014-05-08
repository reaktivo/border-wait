fs = require 'fs'
assert = require 'assert'
difflet = require('difflet')({indent: 2})
{ join } = require 'path'

_ = require 'underscore'

BorderWait = require '../src/border-wait'
BorderWait.prototype._load = (done) ->
  stubPath = join __dirname, 'stubs', "bwt.xml"
  fs.readFile stubPath, (err, data) -> done(err, data.toString())

keys = "lane type id port status updated_at delay".split(" ")

border = new BorderWait()
query = {port: 'San Ysidro', type: 'passenger', lane: 'sentri'}

describe 'Border Wait', ->

  it 'should get border wait times, via Callback', (done) ->
    border.ports (err, reports) ->
      assert Array.isArray(reports), "Reports object should be an array"
      done(err, reports)

  it 'should get border wait times, via Promise', (done) ->
    border.ports().then (reports) ->
      assert Array.isArray(reports), "Reports object should be an array"
      done()

  it 'should find San Ysidro Passenger Sentri lane', (done) ->
    border.findWhere(query)
      .then (report) ->
        assert report.delay is 45, 'Report delay incorrect'
        done()
      .fail (err) -> done(err)

  it 'should parse dates as unix timestamp', (done) ->
    border.findWhere(query)
      .then (report) ->
        updated_at = 1398726000
        assert report.updated_at is timeshould, "Incorrect value for updated_at\nReported as #{report.updated_at}, when it should have been #{updated_at}"
        done()
      .fail (err) -> done(err)
