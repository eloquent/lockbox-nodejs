###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

Exception = require './Exception'

module.exports = class InvalidPublicKeyException extends Exception

  constructor: (@key, cause) ->
    super 'The supplied key is not a valid PEM formatted public key.', cause
