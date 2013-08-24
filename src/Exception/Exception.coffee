###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

module.exports = class Exception

  constructor: (message, cause) ->
    cause = null if cause is undefined
    @_message = message
    @_cause = cause

  message: ->
    @_message

  cause: ->
    @_cause

  toString: ->
    @message()
