BorderWait = require './border-wait'
EventEmitter = require('eventemitter2').EventEmitter2;
{ first, last, each, findWhere, reject } = require 'underscore'

# Set default interval for updates to two minutes
defaultInterval = 2 * 60 * 1000

class BorderWaitReporter extends EventEmitter

  # Keep a reference to last loaded reports
  @reports: undefined

  # Create instance of BorderWait scraper and
  # setup update interval and do initial update.
  constructor: (@interval = defaultInterval) ->
    @border = new BorderWait()
    @resume yes

  # Get new port data and compare with old one
  update: => @border.ports().then @handle

  # Handler report loading, extract new reports
  # then call @publish with each of them as an argument.
  handle: (reports) =>
    if @reports
      newReports = @extractNew(reports, @reports)
      each newReports, (report) => @emit 'report', report
      @emit 'reports', newReports
    else
      @reports = reports
    do @resume if @intervalId

  # Pause updating
  pause: =>
    clearInterval @intervalId
    @intervalId = null

  # Resume updating
  resume: (immediate) =>
    @intervalId = setTimeout @update, @interval
    do @update if immediate

  # Returns an array with only the difference between
  # a new set and an old set of reports.
  extractNew: (newSet, oldSet) ->
    reject newSet, (report) ->
      findWhere oldSet, report

module.exports = BorderWaitReporter