# BorderWaitReporter

This module can be used as a standalone way of obtaining new
BorderWait time reports. It can be used in the following way:

```
var BorderWaitReporter = require('border-wait/reporter');
var reporter = new BorderWaitReporter()
reporter.on('report', function(report) {
  // This function will only be called when new reports are found
})
```

Require BorderWait and EventEmmiter,
BorderWaitReporter provides and EventEmitter interface to detect
when a new report has been detected.

We also extract useful functions from underscore.

    BorderWait = require './border-wait'
    EventEmitter = require('eventemitter2').EventEmitter2;
    { first, last, each, findWhere, reject, pick } = require 'underscore'
    queryKeys = ['port_id', 'lane', 'type', 'delay']


Set the default interval for updates to two minutes

    defaultInterval = 2 * 60 * 1000

We create the BorderWaitReporter class which extends EventEmmiter

    class BorderWaitReporter extends EventEmitter

The constructor creates an instance of BorderWait scraper and
setups it's interval for updates.

      constructor: (opts) ->
        @interval = opts.interval or 2 * 60 * 1000
        @ignoreFirst = opts.ignoreFirst or no
        @eventName = 'report'
        @border = new BorderWait()

We then overwrite EventEmitter's `@on` and `@off` methods and use them
to start and stop the update interval.

      on: (type, listener) ->
        @resume yes if type is @eventName
        super type, listener

      off: (type, listener) ->
        @pause() if @listeners(@eventName).length is 0
        super type, listener

`@update` is called whenever we need fresh new data from CBP,
and then calls `@handle` when it's done. `@handle` takes care of
extracting new reports and `emit`ing events with report data.

      update: =>
        @border.ports().then @handle

      handle: (reports) =>
        if @reports or not @ignoreFirst
          newReports = @extractNew(reports, @reports)
          each newReports, (report) => @emit @eventName, report
        @reports = reports
        do @resume if @timeoutId

`@pause` and `@resume` may be called directly on the instance,
but they are mostly used by the `on` and `off` methods.

      pause: =>
        clearTimeout @timeoutId
        @timeoutId = null

      resume: (immediate) =>
        @timeoutId = setTimeout @update, @interval
        do @update if immediate

`@extractNew` is a simple method that takes two json objects
and returns only an array containing differences.

      extractNew: (newSet, oldSet) ->
        if oldSet?.length is 0
          return newSet
        reject newSet, (report) ->
          report = pick report, queryKeys
          findWhere oldSet, report

Finally, we export the BorderWaitReporter class.

    module.exports = BorderWaitReporter