###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

DecryptionCipher = require './DecryptionCipher'
EncryptionCipher = require './EncryptionCipher'

###*
# The standard Lockbox bi-directional cipher.
#
# @class lockbox.Cipher
###
module.exports = class Cipher

  ###*
  # @class lockbox.Cipher
  # @constructor
  #
  # @param {lockbox.EncryptionCipher} [encryptionCipher] The encryption cipher to use.
  # @param {lockbox.DecryptionCipher} [decryptionCipher] The decryption cipher to use.
  ###
  constructor: ( \
    encryptionCipher = new EncryptionCipher,
    decryptionCipher = new DecryptionCipher
  ) ->
    @_encryptionCipher = encryptionCipher
    @_decryptionCipher = decryptionCipher

  ###*
  # Encrypt a data packet.
  #
  # @method encrypt
  #
  # @param {ursa.Key}      key  The key to encrypt with.
  # @param {String|Buffer} data The data to encrypt.
  #
  # @return {Buffer} The encrypted data.
  ###
  encrypt: (key, data) ->
    @_encryptionCipher.encrypt key, data

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
  # @param {ursa.Key}      key  The key to decrypt with.
  # @param {String|Buffer} data The data to decrypt.
  #
  # @return {Buffer} The decrypted data.
  # @throws {lockbox.exception.DecryptionFailedException} If the decryption failed.
  ###
  decrypt: (key, data) ->
    @_decryptionCipher.decrypt key, data
