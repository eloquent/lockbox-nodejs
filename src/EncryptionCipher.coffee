###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

InvalidPublicKeyException = require './Exception/InvalidPublicKeyException'

###*
# The standard Lockbox encryption cipher.
#
# @class lockbox.EncryptionCipher
###
module.exports = class EncryptionCipher

  ###*
  # @class lockbox.EncryptionCipher
  # @constructor
  #
  # @param {crypto} [crypto] The cryptography module to use.
  # @param {ursa}   [ursa]   The Ursa module to use.
  ###
  constructor: (crypto = (require 'crypto'), ursa = (require 'ursa')) ->
    @_crypto = crypto
    @_ursa = ursa

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
    try
      @_ursa.assertKey key
    catch error
      throw new InvalidPublicKeyException key, error

    data = new Buffer data, 'binary' if not Buffer.isBuffer data

    generatedKey = @_generateKey()
    iv = @_generateIv()

    encryptedKeyAndIv = key.encrypt Buffer.concat [generatedKey, iv]

    hash = @_crypto.createHash 'sha1'
    hash.update data
    digest = hash.digest()

    encryptedData = @_encryptAes generatedKey, iv, Buffer.concat [data, digest]
    @_base64UriEncode Buffer.concat [encryptedKeyAndIv, encryptedData]

  _generateKey: ->
    new Buffer @_crypto.randomBytes(32), 'binary'

  _generateIv: ->
    new Buffer @_crypto.randomBytes(16), 'binary'

  _encryptAes: (key, iv, data) ->
    cipher = @_crypto.createCipheriv 'aes-256-cbc', key, iv
    Buffer.concat [cipher.update(data), cipher.final()]

  _base64UriEncode: (data) ->
    data = data.toString 'base64'
    data = data.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '')
    new Buffer data, 'binary'
