###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

DecryptionCipher = require './DecryptionCipher'
InvalidPrivateKeyException = require './Exception/InvalidPrivateKeyException'

###*
# The standard Lockbox decryption cipher, with a bound key.
#
# @class lockbox.BoundDecryptionCipher
###
module.exports = class BoundDecryptionCipher

  ###*
  # @class lockbox.BoundDecryptionCipher
  # @constructor
  #
  # @param {ursa.Key}                 key                The key to decrypt with.
  # @param {lockbox.DecryptionCipher} [decryptionCipher] The decryption cipher to use.
  # @param {ursa}                     [ursa]             The Ursa module to use.
  ###
  constructor: ( \
    key,
    decryptionCipher = new DecryptionCipher,
    ursa = (require 'ursa')
  ) ->
    try
      ursa.assertPrivateKey key
    catch error
      throw new InvalidPrivateKeyException key, error

    @_key = key
    @_decryptionCipher = decryptionCipher

  ###*
  # Decrypt a data packet.
  #
  # Throws:
  #
  #   - {{#crossLink "lockbox.exception.DecryptionFailedException"}}
  #       lockbox.exception.DecryptionFailedException
  #     {{/crossLink}}
  #     If the decryption failed.
  #
  # @method decrypt
  #
  # @param {String|Buffer} data The data to decrypt.
  #
  # @return {Buffer} The decrypted data.
  # @throws {lockbox.exception.DecryptionFailedException} If the decryption failed.
  ###
  decrypt: (data) ->
    @_decryptionCipher.decrypt @_key, data
