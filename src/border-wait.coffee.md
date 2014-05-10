# BorderWait

This module is used to extract border wait times from the
Customs and Border Patrol website.

We start by importing the modules we are going to use.
BorderWait is a Promise and callback based, you can use it
any way you like. Promises are based on [Q module](https://github.com/kriskowal/q)

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

`@load` basically wraps `_load` in a Promise, you shouldn't usually
call this function directly.

      load: =>
        def = Q.defer()
        @_load def.makeNodeResolver()
        def.promise

`@ports` can be used both in a Promise or callback style.

```
border = new BorderWait()
border.ports(function(err, reports) {
  // handle reports or err
});

// or
border.ports().then(function(reports) {
  // handle reports
}).fail(function(err) {
  // handle error
});
```

      ports: (done) =>
        @load().then(parser.extract).nodeify(done)

We extend our class with some underscore methods that works as shorthand
to manipulate the reports array, take the following as an example:

```
border = new BorderWait()
border.findWhere({port: 'San Ysidro'}).then(function(reports) {
  // Reports will consist only of reports where port equals 'San Ysidro'
})
```

    methods = 'each map where find findWhere pluck sortBy groupBy indexBy'.split(' ')
    each methods, (meth) ->
      BorderWait.prototype[meth] = ->
        args = toArray arguments
        fn = (reports) ->
          _[meth].apply undefined, [reports].concat(args)
        @ports().then(fn)

We finally export the BorderWait class as our module

    module.exports = BorderWait