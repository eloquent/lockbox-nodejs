###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

util = require 'util'
Exception = require './Exception'

###*
# Could not read from the specified path.
#
# @class lockbox.exception.ReadException
###
module.exports = class ReadException extends Exception

  ###*
  # @class lockbox.exception.ReadException
  # @constructor
  #
  # @param {String} path    The unreadable path.
  # @param {mixed}  [cause] The cause, if available.
  ###
  constructor: (@path, cause) ->
    message = util.format "Unable to read from '%s'.", @path
    super message, cause
