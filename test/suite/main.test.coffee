###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

{assert} = require 'chai'
path = require 'path'
lockbox = require '../../' + process.env.TEST_ROOT + '/main'
BoundCipher = require '../../' + process.env.TEST_ROOT + '/BoundCipher'
BoundDecryptionCipher = require '../../' + process.env.TEST_ROOT + '/BoundDecryptionCipher'
BoundEncryptionCipher = require '../../' + process.env.TEST_ROOT + '/BoundEncryptionCipher'
Cipher = require '../../' + process.env.TEST_ROOT + '/Cipher'
DecryptionCipher = require '../../' + process.env.TEST_ROOT + '/DecryptionCipher'
EncryptionCipher = require '../../' + process.env.TEST_ROOT + '/EncryptionCipher'
KeyFactory = require '../../' + process.env.TEST_ROOT + '/KeyFactory'
DecryptionFailedException = require '../../' + process.env.TEST_ROOT + '/Exception/DecryptionFailedException'
InvalidPrivateKeyException = require '../../' + process.env.TEST_ROOT + '/Exception/InvalidPrivateKeyException'
InvalidPublicKeyException = require '../../' + process.env.TEST_ROOT + '/Exception/InvalidPublicKeyException'
ReadException = require '../../' + process.env.TEST_ROOT + '/Exception/ReadException'

suite 'Module index', =>

  setup =>
    @fixturePath = path.resolve __dirname, '../fixture/pem'
    @key = lockbox.keyFactory.createPrivateKeyFromFileSync path.resolve @fixturePath, 'rsa-2048-nopass.private.pem'

  test '- Exports', =>
    assert.strictEqual lockbox.BoundCipher, BoundCipher
    assert.strictEqual lockbox.BoundDecryptionCipher, BoundDecryptionCipher
    assert.strictEqual lockbox.BoundEncryptionCipher, BoundEncryptionCipher
    assert.strictEqual lockbox.Cipher, Cipher
    assert.strictEqual lockbox.DecryptionCipher, DecryptionCipher
    assert.strictEqual lockbox.EncryptionCipher, EncryptionCipher
    assert.strictEqual lockbox.KeyFactory, KeyFactory
    assert.strictEqual lockbox.exception.DecryptionFailedException, DecryptionFailedException
    assert.strictEqual lockbox.exception.InvalidPrivateKeyException, InvalidPrivateKeyException
    assert.strictEqual lockbox.exception.InvalidPublicKeyException, InvalidPublicKeyException
    assert.strictEqual lockbox.exception.ReadException, ReadException
    assert.instanceOf lockbox.keyFactory, KeyFactory

  suite '- Encrypt / decrypt', =>

    @encryptionData =
      'Empty string': ''
      'Short data': 'foobar'
      'Long data': ''
    @encryptionData['Long data'] += 'A' for [1..8192]

    for name, data of @encryptionData
      test '- ' + name, =>
        encrypted = lockbox.encrypt @key, data
        decrypted = lockbox.decrypt @key, encrypted

        assert.strictEqual decrypted.toString('binary'), data
