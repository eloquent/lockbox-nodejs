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
    generatedKey = @_generateKey()
    iv = @_generateIv()

    encryptedKeyAndIv = key.encrypt generatedKey + iv, 'binary', 'binary'

    hash = @_crypto.createHash 'sha1'
    hash.update data, 'binary'
    digest = hash.digest 'binary'

    encryptedData = @_encryptAes generatedKey, iv, digest + data
    encrypted = @_base64UriEncode encryptedKeyAndIv + encryptedData
    new Buffer encrypted, 'binary'

  _generateKey: ->
    @_crypto.randomBytes 32

  _generateIv: ->
    @_crypto.randomBytes 16

  _encryptAes: (key, iv, data) ->
    cipher = @_crypto.createCipheriv 'aes-256-cbc', key, iv
    encrypted = cipher.update data, 'binary', 'binary'
    encrypted + cipher.final 'binary'

  _base64UriEncode: (data) ->
    data = new Buffer data, 'binary'
    data = data.toString 'base64'
    data.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '')
