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
Cipher = require '../../' + process.env.TEST_ROOT + '/Cipher'
EncryptionCipher = require '../../' + process.env.TEST_ROOT + '/EncryptionCipher'
DecryptionCipher = require '../../' + process.env.TEST_ROOT + '/DecryptionCipher'
KeyFactory = require '../../' + process.env.TEST_ROOT + '/KeyFactory'
DecryptionFailedException = require '../../' + process.env.TEST_ROOT + '/Exception/DecryptionFailedException'
InvalidPublicKeyException = require '../../' + process.env.TEST_ROOT + '/Exception/InvalidPublicKeyException'

suite 'Cipher', =>

  base64UriEncode = (data) =>
    data = new Buffer data, 'binary' if not Buffer.isBuffer data
    data = data.toString 'base64'
    data = data.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '')
    new Buffer data, 'binary'

  setup =>
    @encryptionCipher = new EncryptionCipher
    @decryptionCipher = new DecryptionCipher
    @cipher = new Cipher @encryptionCipher, @decryptionCipher

    @fixturePath = path.resolve __dirname, '../fixture/pem'
    @keyFactory = new KeyFactory
    @key = @keyFactory.createPrivateKeyFromFileSync path.resolve @fixturePath, 'rsa-2048-nopass.private.pem'

  suite '#constructor()', =>

    test 'members', =>
      assert.strictEqual @cipher._encryptionCipher, @encryptionCipher
      assert.strictEqual @cipher._decryptionCipher, @decryptionCipher

    test 'member defaults', =>
      @cipher = new Cipher

      assert.instanceOf @cipher._encryptionCipher, EncryptionCipher
      assert.instanceOf @cipher._decryptionCipher, DecryptionCipher

  suite '- Encrypt / decrypt', =>

    @encryptionData =
      'Empty string': ''
      'Short data': 'foobar'
      'Long data': ''
    @encryptionData['Long data'] += 'A' for [1..8192]

    for name, data of @encryptionData
      test '- ' + name, =>
        encrypted = @cipher.encrypt @key, data
        decrypted = @cipher.decrypt @key, encrypted

        assert.strictEqual decrypted.toString('binary'), data

  suite '- Encrypt failures', =>

    test '- Not public key', =>
      callback = =>
        @cipher.encrypt 'foo', 'foobar'

      expect(callback).to.throw InvalidPublicKeyException

  suite '- Decrypt failures', =>

    test '- Not private key', =>
      @key = @keyFactory.createPublicKeyFromFileSync path.resolve @fixturePath, 'rsa-2048-nopass.public.pem'
      callback = =>
        @cipher.decrypt @key, 'foobar'

      expect(callback).to.throw DecryptionFailedException

    test '- Not Base64', =>
      callback = =>
        @cipher.decrypt @key, 'foo:bar'

      expect(callback).to.throw DecryptionFailedException

    test '- Bad data', =>
      callback = =>
        @cipher.decrypt @key, 'foobar'

      expect(callback).to.throw DecryptionFailedException

    test '- Empty key', =>
      data = new Buffer ' ', 'binary'
      data = @key.encrypt data
      data = base64UriEncode data
      callback = =>
        @cipher.decrypt @key, data

      expect(callback).to.throw DecryptionFailedException

    test '- Empty IV', =>
      data = new Buffer crypto.randomBytes(32), 'binary'
      data = @key.encrypt data
      data = base64UriEncode data
      callback = =>
        @cipher.decrypt @key, data

      expect(callback).to.throw DecryptionFailedException

    test '- Bad AES data', =>
      data = new Buffer crypto.randomBytes(48), 'binary'
      data = @key.encrypt data
      data = base64UriEncode data + 'foobar'
      callback = =>
        @cipher.decrypt @key, data

      expect(callback).to.throw DecryptionFailedException

    test '- Bad padding', =>
      key = new Buffer crypto.randomBytes(32), 'binary'
      iv = new Buffer crypto.randomBytes(16), 'binary'
      keyAndIv = @key.encrypt Buffer.concat [key, iv]
      padding = ''
      padding += String.fromCharCode(15) for [1..10]
      data = new Buffer '123456789012345678' + padding, 'binary'
      hash = crypto.createHash 'sha1'
      hash.update data
      digest = hash.digest()
      data = Buffer.concat [digest, data]
      cipher = crypto.createCipheriv 'aes-256-cbc', key, iv
      cipher.setAutoPadding false
      data = Buffer.concat [cipher.update(data), cipher.final()]
      data = base64UriEncode Buffer.concat [keyAndIv, data]
      callback = =>
        @cipher.decrypt @key, data

      expect(callback).to.throw DecryptionFailedException

    test '- Bad hash', =>
      key = new Buffer crypto.randomBytes(32), 'binary'
      iv = new Buffer crypto.randomBytes(16), 'binary'
      keyAndIv = @key.encrypt Buffer.concat [key, iv]
      data = new Buffer 'foobar', 'binary'
      hash = crypto.createHash 'sha1'
      hash.update new Buffer('barfoo', 'binary')
      digest = hash.digest()
      data = Buffer.concat [digest, data]
      cipher = crypto.createCipheriv 'aes-256-cbc', key, iv
      data = Buffer.concat [cipher.update(data), cipher.final()]
      data = base64UriEncode Buffer.concat [keyAndIv, data]
      callback = =>
        @cipher.decrypt @key, data

      expect(callback).to.throw DecryptionFailedException
