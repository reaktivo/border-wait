border-wait
========

[![Package Info](http://img.shields.io/badge/npm-border_wait-blue.svg)](https://npmjs.org/package/border-wait)
[![NPM Version](http://img.shields.io/npm/v/border-wait.svg)](https://npmjs.org/package/border-wait)
[![Build Status](http://img.shields.io/travis/reaktivo/border-wait/master.svg)](http://travis-ci.org/reaktivo/border-wait)
[![Dependencies Status](https://david-dm.org/reaktivo/border-wait.svg?theme=shields.io)](https://david-dm.org/reaktivo/border-wait)
[![DevDependencies Status](https://david-dm.org/reaktivo/border-wait/dev-status.svg?theme=shields.io)](https://david-dm.org/reaktivo/border-wait#info=devDependencies)

Un módulo Nodejs para obtener el tiempo de espera de las garitas de Estados Unidos.

## Para instalar:

    npm install border-wait@latest --save

## Testing

    npm test

## Para usar

    var wait = require('border-wait');

    wait('san_ysidro', function(err, reports) {
      console.log(reports);
      /*
      [ { lane: 'standard',
        delay: 120,
        type: 'vehicular',
        port: 'san_ysidro' },
      { lane: 'sentri',
        delay: 15,
        type: 'vehicular',
        port: 'san_ysidro' },
      { lane: 'readylane',
        delay: 70,
        type: 'vehicular',
        port: 'san_ysidro' },
      { lane: 'standard',
        delay: 70,
        type: 'pedestrian',
        port: 'san_ysidro' },
      { lane: 'readylane',
        delay: 40,
        type: 'pedestrian',
        port: 'san_ysidro' } ]
        */
    })

También puedes escribir tu código con Promises

    wait('san_ysidro').done(function(reports) {
      console.log(reports);
    })


El objeto Promise es extendido con los siguientes métodos de `underscore`:
`each map where find findWhere pluck sortBy groupBy indexBy`. Por lo que puedes
hacer lo siguiente:

    var border = require('border-wait');
    var query = {port: 'san_ysidro', lane: 'sentri'}
    border('san_ysidro').findWhere(query, function(result) {
      /* result ==
        { lane: 'sentri',
          delay: 15,
          type: 'vehicular',
          port: 'san_ysidro' }
      */
    })


## Licencia
BSD-2-Clause

