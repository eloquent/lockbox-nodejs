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
BoundDecryptionCipher = require '../../' + process.env.TEST_ROOT + '/BoundDecryptionCipher'
EncryptionCipher = require '../../' + process.env.TEST_ROOT + '/EncryptionCipher'
DecryptionCipher = require '../../' + process.env.TEST_ROOT + '/DecryptionCipher'
KeyFactory = require '../../' + process.env.TEST_ROOT + '/KeyFactory'
InvalidPrivateKeyException = require '../../' + process.env.TEST_ROOT + '/Exception/InvalidPrivateKeyException'

suite 'BoundDecryptionCipher', =>

  setup =>
    @fixturePath = path.resolve __dirname, '../fixture/pem'
    @keyFactory = new KeyFactory
    @key = @keyFactory.createPrivateKeyFromFileSync path.resolve @fixturePath, 'rsa-2048-nopass.private.pem'
    @decryptionCipher = new DecryptionCipher
    @cipher = new BoundDecryptionCipher @key, @decryptionCipher

    @encryptionCipher = new EncryptionCipher

  suite '#constructor()', =>

    test 'members', =>
      assert.strictEqual @cipher._key, @key
      assert.strictEqual @cipher._decryptionCipher, @decryptionCipher

    test 'member defaults', =>
      @cipher = new BoundDecryptionCipher @key

      assert.instanceOf @cipher._decryptionCipher, DecryptionCipher

    test 'invalid key', =>
      callback = =>
        key = @keyFactory.createPublicKeyFromFileSync path.resolve @fixturePath, 'rsa-2048-nopass.public.pem'
        new BoundDecryptionCipher key

      expect(callback).to.throw InvalidPrivateKeyException

  suite '- Encrypt / decrypt', =>

    @encryptionData =
      'Empty string': ''
      'Short data': 'foobar'
      'Long data': ''
    @encryptionData['Long data'] += 'A' for [1..8192]

    for name, data of @encryptionData
      test '- ' + name, =>
        encrypted = @encryptionCipher.encrypt @key, data
        decrypted = @cipher.decrypt encrypted

        assert.strictEqual decrypted.toString('binary'), data
