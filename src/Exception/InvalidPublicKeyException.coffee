###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

Exception = require './Exception'

###*
# The supplied key is not a valid PEM formatted public key.
#
# @class lockbox.exception.InvalidPublicKeyException
###
module.exports = class InvalidPublicKeyException extends Exception

  ###*
  # @class lockbox.exception.InvalidPublicKeyException
  # @constructor
  #
  # @param {mixed} key     The invalid key.
  # @param {mixed} [cause] The cause, if available.
  ###
  constructor: (@key, cause) ->
    super 'The supplied key is not a valid PEM formatted public key.', cause
