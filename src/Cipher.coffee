###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

DecryptionCipher = require './DecryptionCipher'
EncryptionCipher = require './EncryptionCipher'

module.exports = class Cipher

  constructor: ( \
    encryptionCipher = new EncryptionCipher,
    decryptionCipher = new DecryptionCipher
  ) ->
    @_encryptionCipher = encryptionCipher
    @_decryptionCipher = decryptionCipher

  encrypt: (key, data) ->
    @_encryptionCipher.encrypt key, data

  decrypt: (key, data) ->
    @_decryptionCipher.decrypt key, data
