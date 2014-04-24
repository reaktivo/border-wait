try {
  module.exports = require('./lib/border-wait')
} catch(e) {
  require('coffee-script/register')
  module.exports = require('./src/border-wait')
}