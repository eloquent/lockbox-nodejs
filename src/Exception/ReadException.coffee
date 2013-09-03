###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

util = require 'util'
Exception = require './Exception'

module.exports = class ReadException extends Exception

  constructor: (@path, cause) ->
    message = util.format "Unable to read from '%s'.", @path
    super message, cause
