###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

Exception = require './Exception'

###*
# Decryption failed.
#
# @class lockbox.exception.DecryptionFailedException
###
module.exports = class DecryptionFailedException extends Exception

  ###*
  # @class lockbox.exception.DecryptionFailedException
  # @constructor
  #
  # @param {mixed} [cause] The cause, if available.
  ###
  constructor: (cause) ->
    super 'Decryption failed.', cause
