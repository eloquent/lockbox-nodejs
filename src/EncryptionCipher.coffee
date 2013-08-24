###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

module.exports = class EncryptionCipher

  constructor: (crypto = (require 'crypto')) ->
    @_crypto = crypto

  encrypt: (key, data) ->
    data = new Buffer data, 'binary' if not Buffer.isBuffer data
    generatedKey = @_generateKey()
    iv = @_generateIv()

    encryptedKeyAndIv = key.encrypt Buffer.concat [generatedKey, iv]

    hash = @_crypto.createHash 'sha1'
    hash.update data
    digest = hash.digest()

    encryptedData = @_encryptAes generatedKey, iv, Buffer.concat [digest, data]
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
