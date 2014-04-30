request = require 'request'
Q = require 'q'
_ = require 'underscore'
{ each, toArray, last } = _

parser = require './parser'
endpoint = 'http://apps.cbp.gov/bwt/bwt.xml'


class BorderWait

  parser: parser
  endpoint: endpoint

  _load: (done) ->
    request endpoint, (err, res, html) -> done(err, html)

  load: =>
    def = Q.defer()
    @_load def.makeNodeResolver()
    def.promise

  ports: (done) =>
    @load().then(parser.extract).nodeify(done)

methods = 'each map where find findWhere pluck sortBy groupBy indexBy'.split(' ')
each methods, (meth) ->
  BorderWait.prototype[meth] = ->
    args = toArray arguments
    fn = (reports) ->
      _[meth].apply undefined, [reports].concat(args)
    @ports().then(fn)

module.exports = BorderWait