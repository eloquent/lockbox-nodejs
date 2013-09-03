###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

{assert, expect} = require 'chai'
crypto = require 'crypto'
path = require 'path'
sinon = require 'sinon'
BoundEncryptionCipher = require '../../' + process.env.TEST_ROOT + '/BoundEncryptionCipher'
EncryptionCipher = require '../../' + process.env.TEST_ROOT + '/EncryptionCipher'
DecryptionCipher = require '../../' + process.env.TEST_ROOT + '/DecryptionCipher'
KeyFactory = require '../../' + process.env.TEST_ROOT + '/KeyFactory'
InvalidPublicKeyException = require '../../' + process.env.TEST_ROOT + '/Exception/InvalidPublicKeyException'

suite 'BoundEncryptionCipher', =>

  setup =>
    @fixturePath = path.resolve __dirname, '../fixture/pem'
    @keyFactory = new KeyFactory
    @key = @keyFactory.createPrivateKeyFromFileSync path.resolve @fixturePath, 'rsa-2048-nopass.private.pem'
    @encryptionCipher = new EncryptionCipher
    @cipher = new BoundEncryptionCipher @key, @encryptionCipher

    @decryptionCipher = new DecryptionCipher

  suite '#constructor()', =>

    test 'members', =>
      assert.strictEqual @cipher._key, @key
      assert.strictEqual @cipher._encryptionCipher, @encryptionCipher

    test 'member defaults', =>
      @cipher = new BoundEncryptionCipher @key

      assert.instanceOf @cipher._encryptionCipher, EncryptionCipher

    test 'invalid key', =>
      callback = =>
        new BoundEncryptionCipher 'foo'

      expect(callback).to.throw InvalidPublicKeyException

  suite '- Encrypt / decrypt', =>

    @encryptionData =
      'Empty string': ''
      'Short data': 'foobar'
      'Long data': ''
    @encryptionData['Long data'] += 'A' for [1..8192]

    for name, data of @encryptionData
      test '- ' + name, =>
        encrypted = @cipher.encrypt data
        decrypted = @decryptionCipher.decrypt @key, encrypted

        assert.strictEqual decrypted.toString('binary'), data
