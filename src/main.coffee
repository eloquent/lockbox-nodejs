###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

BoundCipher = require './BoundCipher'
BoundDecryptionCipher = require './BoundDecryptionCipher'
BoundEncryptionCipher = require './BoundEncryptionCipher'
Cipher = require './Cipher'
DecryptionCipher = require './DecryptionCipher'
EncryptionCipher = require './EncryptionCipher'
KeyFactory = require './KeyFactory'
DecryptionFailedException = require './Exception/DecryptionFailedException'
InvalidPrivateKeyException = require './Exception/InvalidPrivateKeyException'
InvalidPublicKeyException = require './Exception/InvalidPublicKeyException'
ReadException = require './Exception/ReadException'

encryptionCipher = new EncryptionCipher
decryptionCipher = new DecryptionCipher
keyFactory = new KeyFactory

###*
# The main Lockbox module.
#
# @class lockbox
# @static
###
module.exports =

  ###*
  # The bound bi-directional cipher class.
  #
  # @property {Function} BoundCipher
  ###
  BoundCipher: BoundCipher

  ###*
  # The bound decryption cipher class.
  #
  # @property {Function} BoundDecryptionCipher
  ###
  BoundDecryptionCipher: BoundDecryptionCipher

  ###*
  # The bound encryption cipher class.
  #
  # @property {Function} BoundEncryptionCipher
  ###
  BoundEncryptionCipher: BoundEncryptionCipher

  ###*
  # The bi-directional cipher class.
  #
  # @property {Function} Cipher
  ###
  Cipher: Cipher

  ###*
  # The decryption cipher class.
  #
  # @property {Function} DecryptionCipher
  ###
  DecryptionCipher: DecryptionCipher

  ###*
  # The bound encryption cipher class.
  #
  # @property {Function} EncryptionCipher
  ###
  EncryptionCipher: EncryptionCipher

  ###*
  # The key factory class.
  #
  # @property {Function} KeyFactory
  ###
  KeyFactory: KeyFactory

  exception:

    ###*
    # The decryption failed exception class.
    #
    # @property {Function} exception.DecryptionFailedException
    ###
    DecryptionFailedException: DecryptionFailedException

    ###*
    # The invalid private key exception class.
    #
    # @property {Function} exception.InvalidPrivateKeyException
    ###
    InvalidPrivateKeyException: InvalidPrivateKeyException

    ###*
    # The invalid public key exception class.
    #
    # @property {Function} exception.InvalidPublicKeyException
    ###
    InvalidPublicKeyException: InvalidPublicKeyException

    ###*
    # The read exception class.
    #
    # @property {Function} exception.ReadException
    ###
    ReadException: ReadException

  ###*
  # A key factory instance.
  #
  # @property {lockbox.KeyFactory} keyFactory
  ###
  keyFactory: keyFactory

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
    encryptionCipher.encrypt key, data

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
    decryptionCipher.decrypt key, data
