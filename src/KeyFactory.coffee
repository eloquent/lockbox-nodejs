###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

InvalidPrivateKeyException = require './Exception/InvalidPrivateKeyException'
InvalidPublicKeyException = require './Exception/InvalidPublicKeyException'

module.exports = class KeyFactory

  constructor: (ursa = (require 'ursa'), fs = (require 'fs')) ->
    @_ursa = ursa
    @_fs = fs

  createPrivateKey: (key, password) ->
    password = undefined if not password
    try
      keyObject = @_ursa.createPrivateKey key, password
    catch error
      throw new InvalidPrivateKeyException key
    return keyObject

  createPublicKey: (key) ->
    try
      keyObject = @_ursa.createPublicKey key
    catch error
      throw new InvalidPublicKeyException key
    return keyObject

  createPrivateKeyFromFile: (path, password, callback) ->
    @_fs.readFile path, {}, (error, key) =>
      return callback error if error
      try
        keyObject = @createPrivateKey key, password
      catch error
        return callback error
      callback null, keyObject

  createPrivateKeyFromFileSync: (path, password, callback) ->
    key = @_fs.readFileSync path
    @createPrivateKey key, password

  createPublicKeyFromFile: (path, callback) ->
    @_fs.readFile path, {}, (error, key) =>
      return callback error if error
      try
        keyObject = @createPublicKey key
      catch error
        return callback error
      callback null, keyObject

  createPublicKeyFromFileSync: (path, callback) ->
    @createPublicKey @_fs.readFileSync path
