###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

EncryptionCipher = require './EncryptionCipher'
InvalidPublicKeyException = require './Exception/InvalidPublicKeyException'

###*
# The standard Lockbox encryption cipher, with a bound key.
#
# @class lockbox.BoundEncryptionCipher
###
module.exports = class BoundEncryptionCipher

  ###*
  # @class lockbox.BoundEncryptionCipher
  # @constructor
  #
  # @param {ursa.Key}                 key                The key to encrypt with.
  # @param {lockbox.EncryptionCipher} [encryptionCipher] The encryption cipher to use.
  # @param {ursa}                     [ursa]             The Ursa module to use.
  ###
  constructor: ( \
    key,
    encryptionCipher = new EncryptionCipher,
    ursa = (require 'ursa')
  ) ->
    try
      ursa.assertKey key
    catch error
      throw new InvalidPublicKeyException key, error

    @_key = key
    @_encryptionCipher = encryptionCipher

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
