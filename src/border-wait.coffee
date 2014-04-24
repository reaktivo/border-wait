request = require 'request'
Q = require 'q'
_ = require 'underscore'
{ each, toArray, last } = _

parser = require './parser'
ports = require './ports'

methods = 'each map where find findWhere pluck sortBy groupBy indexBy'.split(' ')

class BorderWait

  parser: parser
  ports: ports
  reports: []

  constructor: (port, done) ->
    return if port and done is undefined
      @load port
    else if done
      @load port, done


  _load: (port, done) ->
    request ports[port], (err, res, body) => done(err, body)

  load: (port, done) ->
    deferred = Q.defer()
    @_load port, (err, body) =>
      if err
        deferred.reject new Error err
        done err if done
      else
        @reports = @extract body, port
        deferred.resolve @reports
        done null, @reports if done
    extendedPromise deferred.promise

  extract: (body, port) ->
    reports = parser(body).reports
    if port
      for report in reports
        report.port = port
        report
    else
      reports

methods.forEach (fn) ->
  BorderWait.prototype[fn] = ->
    _[fn].apply null, [@reports].concat toArray(arguments)

extendedPromise = (promise) ->
  methods.forEach (fn) ->
    promise[fn] = ->
      args = toArray(arguments)
      _args = args.slice 0, -1
      callback = last args
      promise.done (reports) ->
        callback _[fn].apply null, [reports].concat _args
  promise



module.exports = (port, done) -> new BorderWait(port, done)