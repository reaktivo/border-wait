# index.coffee.md

When requiring the `border-wait` module we want to
return an already initialized instance. If you ever
need a reference to the `BorderWait` class directly
just use `require('border-wait/border-wait')`

    BorderWait = require './border-wait'
    module.exports = new BorderWait