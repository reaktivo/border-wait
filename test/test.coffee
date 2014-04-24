fs = require 'fs'
assert = require 'assert'
difflet = require('difflet')({indent: 2})
{ join } = require 'path'

border = require '../index'

# Patch library to load locally
load = (port, done) ->
  stubPath = join __dirname, 'stubs', "#{port}.xml"
  fs.readFile stubPath, (err, data) -> done(err, data.toString())

expectedReports = (port) ->
  require join __dirname, 'stubs', "#{port}.js"

b = border()
b.constructor.prototype._load = load

describe 'Border Wait', ->

  port = 'san_ysidro'
  expected = expectedReports port

  it 'should get border wait times, via Callback', (done) ->
    border port, (err, reports) ->
      diff = difflet.compare(reports, expected)
      message = "Report not equal to expected\n#{diff}"
      assert.deepEqual reports, expected, message
      done(err, reports)

  it 'should get border wait times, via Promise', (done) ->
    border().load('san_ysidro')
      .fail (err) -> done(err)
      .done (reports) ->
        diff = difflet.compare(reports, expected)
        message = "Report not equal to expected\n#{diff}"
        assert.deepEqual reports, expected, message
        done()

