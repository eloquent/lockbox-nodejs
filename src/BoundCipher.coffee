###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

DecryptionCipher = require './DecryptionCipher'
EncryptionCipher = require './EncryptionCipher'
InvalidPrivateKeyException = require './Exception/InvalidPrivateKeyException'

###*
# The standard Lockbox bi-directional cipher, with a bound key.
#
# @class lockbox.BoundCipher
###
module.exports = class BoundCipher

  ###*
  # @class lockbox.BoundCipher
  # @constructor
  #
  # @param {ursa.Key}                 key                The key to encrypt and decrypt with.
  # @param {lockbox.EncryptionCipher} [encryptionCipher] The encryption cipher to use.
  # @param {lockbox.DecryptionCipher} [decryptionCipher] The decryption cipher to use.
  # @param {ursa}                     [ursa]             The Ursa module to use.
  ###
  constructor: ( \
    key,
    encryptionCipher = new EncryptionCipher,
    decryptionCipher = new DecryptionCipher,
    ursa = (require 'ursa')
  ) ->
    try
      ursa.assertPrivateKey key
    catch error
      throw new InvalidPrivateKeyException key, error

    @_key = key
    @_encryptionCipher = encryptionCipher
    @_decryptionCipher = decryptionCipher

  ###*
  # Encrypt a data packet.
  #
  # @method encrypt
  #
  # @param {String|Buffer} data The data to encrypt.
  #
  # @return {Buffer} The encrypted data.
  ###
  encrypt: (data) ->
    @_encryptionCipher.encrypt @_key, data

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
