try {
  module.exports = require('./lib/reporter')
} catch(e) {
  require('coffee-script/register')
  module.exports = require('./src/reporter')
}