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
BoundCipher = require '../../' + process.env.TEST_ROOT + '/BoundCipher'
EncryptionCipher = require '../../' + process.env.TEST_ROOT + '/EncryptionCipher'
DecryptionCipher = require '../../' + process.env.TEST_ROOT + '/DecryptionCipher'
KeyFactory = require '../../' + process.env.TEST_ROOT + '/KeyFactory'
InvalidPrivateKeyException = require '../../' + process.env.TEST_ROOT + '/Exception/InvalidPrivateKeyException'

suite 'BoundCipher', =>

  setup =>
    @fixturePath = path.resolve __dirname, '../fixture/pem'
    @keyFactory = new KeyFactory
    @key = @keyFactory.createPrivateKeyFromFileSync path.resolve @fixturePath, 'rsa-2048-nopass.private.pem'
    @encryptionCipher = new EncryptionCipher
    @decryptionCipher = new DecryptionCipher
    @cipher = new BoundCipher @key, @encryptionCipher, @decryptionCipher

  suite '#constructor()', =>

    test 'members', =>
      assert.strictEqual @cipher._key, @key
      assert.strictEqual @cipher._encryptionCipher, @encryptionCipher
      assert.strictEqual @cipher._decryptionCipher, @decryptionCipher

    test 'member defaults', =>
      @cipher = new BoundCipher @key

      assert.instanceOf @cipher._encryptionCipher, EncryptionCipher
      assert.instanceOf @cipher._decryptionCipher, DecryptionCipher

    test 'invalid key', =>
      callback = =>
        key = @keyFactory.createPublicKeyFromFileSync path.resolve @fixturePath, 'rsa-2048-nopass.public.pem'
        new BoundCipher key

      expect(callback).to.throw InvalidPrivateKeyException

  suite '- Encrypt / decrypt', =>

    @encryptionData =
      'Empty string': ''
      'Short data': 'foobar'
      'Long data': ''
    @encryptionData['Long data'] += 'A' for [1..8192]

    for name, data of @encryptionData
      test '- ' + name, =>
        encrypted = @cipher.encrypt data
        decrypted = @cipher.decrypt encrypted

        assert.strictEqual decrypted.toString('binary'), data
