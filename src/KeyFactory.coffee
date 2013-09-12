###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

InvalidPrivateKeyException = require './Exception/InvalidPrivateKeyException'
InvalidPublicKeyException = require './Exception/InvalidPublicKeyException'

###*
# Creates encryption keys.
#
# @class lockbox.KeyFactory
###
module.exports = class KeyFactory

  ###*
  # @class lockbox.KeyFactory
  # @constructor
  #
  # @param {ursa} [ursa] The Ursa module to use.
  # @param {fs}   [fs]   The file system module to use.
  ###
  constructor: (ursa = (require 'ursa'), fs = (require 'fs')) ->
    @_ursa = ursa
    @_fs = fs

  ###*
  # Encrypt a data packet.
  #
  # @method generatePrivateKey
  #
  # @param {Number} [size] The key size in bits.
  #
  # @return {ursa.PrivateKey} The generated key.
  ###
  generatePrivateKey: (size) ->
    size = 2048 if not size
    @_ursa.generatePrivateKey size, 65537

  ###*
  # Create a new private key.
  #
  # Throws:
  #
  #   - {{#crossLink "lockbox.exception.InvalidPrivateKeyException"}}
  #       lockbox.exception.InvalidPrivateKeyException
  #     {{/crossLink}}
  #     If the key is invalid.
  #
  # @method createPrivateKey
  #
  # @param {String} key        The PEM formatted private key.
  # @param {String} [password] The key password.
  #
  # @return {ursa.PrivateKey} The private key.
  # @throws {lockbox.exception.InvalidPrivateKeyException} If the key is invalid.
  ###
  createPrivateKey: (key, password) ->
    password = undefined if not password
    try
      keyObject = @_ursa.createPrivateKey key, password
    catch error
      throw new InvalidPrivateKeyException key
    return keyObject

  ###*
  # Create a new public key.
  #
  # Throws:
  #
  #   - {{#crossLink "lockbox.exception.InvalidPublicKeyException"}}
  #       lockbox.exception.InvalidPublicKeyException
  #     {{/crossLink}}
  #     If the key is invalid.
  #
  # @method createPublicKey
  #
  # @param {String} key The PEM formatted public key.
  #
  # @return {ursa.PublicKey} The public key.
  # @throws {lockbox.exception.InvalidPublicKeyException} If the key is invalid.
  ###
  createPublicKey: (key) ->
    try
      keyObject = @_ursa.createPublicKey key
    catch error
      throw new InvalidPublicKeyException key
    return keyObject

  ###*
  # Creates a new private key from a file asynchronously.
  #
  # If successful, the second argument to the callback will be an instance of
  # {{#crossLink "ursa.PrivateKey"}}ursa.PrivateKey{{/crossLink}}. Otherwise,
  # any errors will be returned as the first argument to the callback.
  #
  # Possible errors:
  #
  #   - {{#crossLink "lockbox.exception.ReadException"}}
  #       lockbox.exception.ReadException
  #     {{/crossLink}}
  #     If the file cannot be read.
  #   - {{#crossLink "lockbox.exception.InvalidPrivateKeyException"}}
  #       lockbox.exception.InvalidPrivateKeyException
  #     {{/crossLink}}
  #     If the key is invalid.
  #
  # @method createPrivateKeyFromFile
  # @async
  #
  # @param {String}   path       The path to the PEM formatted private key.
  # @param {String}   [password] The key password.
  # @param {Function} callback   The callback function.
  ###
  createPrivateKeyFromFile: (path, password, callback) ->
    @_fs.readFile path, {}, (error, key) =>
      return callback error if error
      try
        keyObject = @createPrivateKey key, password
      catch error
        return callback error
      callback null, keyObject

  ###*
  # Creates a new private key from a file synchronously.
  #
  # Throws:
  #
  #   - {{#crossLink "lockbox.exception.ReadException"}}
  #       lockbox.exception.ReadException
  #     {{/crossLink}}
  #     If the file cannot be read.
  #   - {{#crossLink "lockbox.exception.InvalidPrivateKeyException"}}
  #       lockbox.exception.InvalidPrivateKeyException
  #     {{/crossLink}}
  #     If the key is invalid.
  #
  # @method createPrivateKeyFromFileSync
  #
  # @param {String}   path       The path to the PEM formatted private key.
  # @param {String}   [password] The key password.
  # @param {Function} callback   The callback function.
  #
  # @return {ursa.PrivateKey} The private key.
  # @throws {lockbox.exception.ReadException}              If the file cannot be read.
  # @throws {lockbox.exception.InvalidPrivateKeyException} If the key is invalid.
  ###
  createPrivateKeyFromFileSync: (path, password) ->
    key = @_fs.readFileSync path
    @createPrivateKey key, password

  ###*
  # Creates a new public key from a file asynchronously.
  #
  # If successful, the second argument to the callback will be an instance of
  # {{#crossLink "ursa.PublicKey"}}ursa.PublicKey{{/crossLink}}. Otherwise, any
  # errors will be returned as the first argument to the callback.
  #
  # Possible errors:
  #
  #   - {{#crossLink "lockbox.exception.ReadException"}}
  #       lockbox.exception.ReadException
  #     {{/crossLink}}
  #     If the file cannot be read.
  #   - {{#crossLink "lockbox.exception.InvalidPublicKeyException"}}
  #       lockbox.exception.InvalidPublicKeyException
  #     {{/crossLink}}
  #     If the key is invalid.
  #
  # @method createPublicKeyFromFile
  # @async
  #
  # @param {String}   path       The path to the PEM formatted public key.
  # @param {String}   [password] The key password.
  # @param {Function} callback   The callback function.
  ###
  createPublicKeyFromFile: (path, callback) ->
    @_fs.readFile path, {}, (error, key) =>
      return callback error if error
      try
        keyObject = @createPublicKey key
      catch error
        return callback error
      callback null, keyObject

  ###*
  # Creates a new public key from a file synchronously.
  #
  # Throws:
  #
  #   - {{#crossLink "lockbox.exception.ReadException"}}
  #       lockbox.exception.ReadException
  #     {{/crossLink}}
  #     If the file cannot be read.
  #   - {{#crossLink "lockbox.exception.InvalidPublicKeyException"}}
  #       lockbox.exception.InvalidPublicKeyException
  #     {{/crossLink}}
  #     If the key is invalid.
  #
  # @method createPublicKeyFromFileSync
  #
  # @param {String}   path       The path to the PEM formatted public key.
  # @param {String}   [password] The key password.
  # @param {Function} callback   The callback function.
  #
  # @return {ursa.PublicKey} The public key.
  # @throws {lockbox.exception.ReadException}             If the file cannot be read.
  # @throws {lockbox.exception.InvalidPublicKeyException} If the key is invalid.
  ###
  createPublicKeyFromFileSync: (path) ->
    @createPublicKey @_fs.readFileSync path
