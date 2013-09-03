###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

BoundCipher = require './BoundCipher'
BoundDecryptionCipher = require './BoundDecryptionCipher'
BoundEncryptionCipher = require './BoundEncryptionCipher'
Cipher = require './Cipher'
DecryptionCipher = require './DecryptionCipher'
EncryptionCipher = require './EncryptionCipher'
KeyFactory = require './KeyFactory'
DecryptionFailedException = require './Exception/DecryptionFailedException'
InvalidPrivateKeyException = require './Exception/InvalidPrivateKeyException'
InvalidPublicKeyException = require './Exception/InvalidPublicKeyException'
ReadException = require './Exception/ReadException'

encryptionCipher = new EncryptionCipher
decryptionCipher = new DecryptionCipher
keyFactory = new KeyFactory

module.exports =

  BoundCipher: BoundCipher
  BoundDecryptionCipher: BoundDecryptionCipher
  BoundEncryptionCipher: BoundEncryptionCipher
  Cipher: Cipher
  DecryptionCipher: DecryptionCipher
  EncryptionCipher: EncryptionCipher
  KeyFactory: KeyFactory

  exception:
    DecryptionFailedException: DecryptionFailedException
    InvalidPrivateKeyException: InvalidPrivateKeyException
    InvalidPublicKeyException: InvalidPublicKeyException
    ReadException: ReadException

  keyFactory: keyFactory

  encrypt: (key, data) ->
    encryptionCipher.encrypt key, data

  decrypt: (key, data) ->
    decryptionCipher.decrypt key, data
