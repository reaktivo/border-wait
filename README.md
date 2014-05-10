border-wait
========

[![Package Info](http://img.shields.io/badge/npm-border_wait-blue.svg)](https://npmjs.org/package/border-wait)
[![NPM Version](http://img.shields.io/npm/v/border-wait.svg)](https://npmjs.org/package/border-wait)
[![Build Status](http://img.shields.io/travis/reaktivo/border-wait/master.svg)](http://travis-ci.org/reaktivo/border-wait)
[![Dependencies Status](https://david-dm.org/reaktivo/border-wait.svg?theme=shields.io)](https://david-dm.org/reaktivo/border-wait)
[![DevDependencies Status](https://david-dm.org/reaktivo/border-wait/dev-status.svg?theme=shields.io)](https://david-dm.org/reaktivo/border-wait#info=devDependencies)

Un módulo Nodejs para obtener el tiempo de espera de las garitas de Estados Unidos.

La librería está escrita en estilo Literate Coffeescript, puedes leer el código fuente junto con comentarios en:

- [BorderWait](https://github.com/reaktivo/border-wait/blob/master/src/border-wait.coffee.md)
- [BorderWaitReporter](https://github.com/reaktivo/border-wait/blob/master/src/reporter.coffee.md)

## Para instalar:

    npm install border-wait@latest --save

## Testing

    npm test

## Para usar

    var border = require('border-wait');

    border(function(err, reports) {
      console.log(reports);
      /*
        Reports es una Array de objetos de los puertos de
        entrada a Estados Unidos.
      */
    });

También puedes escribir tu código con Promises

    var border = require('border-wait');
    border.ports().done(function(reports) {
      console.log(reports);
    })


El objeto Promise es extendido con los siguientes métodos de `underscore`:
`each map where find findWhere pluck sortBy groupBy indexBy`. Por lo que puedes
hacer lo siguiente:

    var border = require('border-wait');
    var query = {port: 'san_ysidro', lane: 'sentri'}
    border.findWhere(query).then function(report){
      /* result ==
        { lane: 'sentri',
          delay: 15,
          type: 'vehicular',
          port: 'san_ysidro' }
      */
    }


## Licencia
BSD-2-Clause

