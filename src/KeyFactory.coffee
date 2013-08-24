###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

module.exports = class KeyFactory

  constructor: (ursa = (require 'ursa'), fs = (require 'fs')) ->
    @_ursa = ursa
    @_fs = fs

  createPrivateKey: (key, password) ->
    password = undefined if not password
    @_ursa.createPrivateKey key, password

  createPublicKey: (key) ->
    @_ursa.createPublicKey key

  createPrivateKeyFromFile: (path, password, callback) ->
    @_fs.readFile path, {}, (error, key) =>
      return callback error if error
      callback null, @createPrivateKey key, password

  createPrivateKeyFromFileSync: (path, password, callback) ->
    key = @_fs.readFileSync path
    @createPrivateKey key, password

  createPublicKeyFromFile: (path, callback) ->
    @_fs.readFile path, {}, (error, key) =>
      return callback error if error
      callback null, @createPublicKey key

  createPublicKeyFromFileSync: (path, callback) ->
    @createPublicKey @_fs.readFileSync path
