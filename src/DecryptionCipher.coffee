###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

DecryptionFailedException = require './Exception/DecryptionFailedException'

module.exports = class DecryptionCipher

  constructor: (crypto = (require 'crypto')) ->
    @_crypto = crypto

  decrypt: (key, data) ->
    data = @_base64UriDecode data

    keyAndIv = data.slice 0, key.getModulus().length
    try
      keyAndIv = key.decrypt keyAndIv
    catch error
      throw new DecryptionFailedException error

    generatedKey = keyAndIv.slice 0, 32
    throw new DecryptionFailedException if generatedKey.length isnt 32

    iv = keyAndIv.slice 32
    throw new DecryptionFailedException if iv.length isnt 16

    data = data.slice key.getModulus().length
    data = @_decryptAes generatedKey, iv, data

    verificationDigest = data.slice(0, 20).toString 'binary'
    data = data.slice 20

    hash = @_crypto.createHash 'sha1'
    hash.update data
    digest = hash.digest().toString 'binary'

    throw new DecryptionFailedException if digest isnt verificationDigest

    return data

  _decryptAes: (key, iv, data) ->
    cipher = @_crypto.createDecipheriv 'aes-256-cbc', key, iv
    Buffer.concat [cipher.update(data), cipher.final()]

  _base64UriDecode: (data) ->
    data = data.toString 'binary' if Buffer.isBuffer data
    data = data.replace(/-/g, '+').replace(/_/g, '/')
    new Buffer data, 'base64'
