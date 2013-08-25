###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

DecryptionCipher = require './DecryptionCipher'
EncryptionCipher = require './EncryptionCipher'
InvalidPrivateKeyException = require './Exception/InvalidPrivateKeyException'

module.exports = class BoundCipher

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

  encrypt: (data) ->
    @_encryptionCipher.encrypt @_key, data

  decrypt: (data) ->
    @_decryptionCipher.decrypt @_key, data
