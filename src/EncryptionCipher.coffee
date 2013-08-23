###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

module.exports = class EncryptionCipher

  constructor: (ursa = (require 'ursa'), crypto = (require 'crypto')) ->
    @_ursa = ursa
    @_crypto = crypto

  encrypt: (key, data) ->
    key = @_ursa.coercePublicKey key
    generatedKey = @_crypto.randomBytes 32
    iv = @_crypto.randomBytes 16

    encryptedKeyAndIv = key.encrypt \
      data,
      'binary',
      'binary',
      @_ursa.RSA_PKCS1_PADDING

    hash = @_crypto.createHash 'sha1'
    hash.update data
    digest = hash.digest 'binary'

    encryptedData = @_encryptAes generatedKey, iv, digest + data

    @_base64UriEncode encryptedKeyAndIv + encryptedData

  _encryptAes: (key, iv, data) ->
    cipher = @_crypto.createCipheriv 'aes-256-cbc', key, iv
