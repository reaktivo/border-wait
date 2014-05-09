fs = require 'fs'
assert = require 'assert'
difflet = require('difflet')({indent: 2})
{ join } = require 'path'
{ all } = require 'underscore'

BorderWait = require '../src/border-wait'
Reporter = require '../src/reporter'
patchLoad = (xml) ->
  BorderWait.prototype._load = (done) ->
    stubPath = join __dirname, 'stubs', xml or "bwt.xml"
    fs.readFile stubPath, (err, data) -> done(err, data.toString())

patchLoad 'bwt.xml'

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
        expected = 15
        assert report.delay is expected, "Report delay incorrect, expected #{expected}, got #{report.delay}"
        done()
      .fail (err) -> done(err)

  it 'should parse dates as unix timestamp', (done) ->
    border.findWhere(query)
      .then (report) ->
        updated_at = 1398733200
        assert report.updated_at is updated_at, "Incorrect value for updated_at\nReturned #{report.updated_at}, expected #{updated_at}\n#{JSON.stringify(report)}"
        done()
      .fail (err) -> done(err)

describe 'Border Wait Reporter', ->

  beforeEach -> patchLoad 'bwt2.xml'
  afterEach -> patchLoad 'bwt.xml'

  it 'should find changed reports only', (done) ->
    reporter = new Reporter(200)
    patchLoad 'bwt.xml'
    reporter.on 'reports', (reports) ->
      assert reports.length is 5, 'Should have detected 5 new reports'
      assert all(reports, (r) -> r.port is 'San Ysidro'), 'All new reports should have San Ysidro as it\'s port'
      done()
