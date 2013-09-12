###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

{assert} = require 'chai'
path = require 'path'
sinon = require 'sinon'
util = require 'util'
lockbox = require '../../' + process.env.TEST_ROOT + '/main'
DecryptionCipher = require '../../' + process.env.TEST_ROOT + '/DecryptionCipher'
EncryptionCipher = require '../../' + process.env.TEST_ROOT + '/EncryptionCipher'
KeyFactory = require '../../' + process.env.TEST_ROOT + '/KeyFactory'

suite 'Functional tests', =>

  setup =>
    @encryptionCipher = new EncryptionCipher
    @decryptionCipher = new DecryptionCipher

    @fixturePath = path.resolve __dirname, '../fixture/pem'
    @keyFactory = new KeyFactory
    @key = @keyFactory.createPrivateKeyFromFileSync path.resolve @fixturePath, 'rsa-2048-nopass.private.pem'

  suite '- Test vectors', =>

    @specVectorData =
      'Test vector 1':
        bits: 2048
        data: ''
        key:  '12345678901234567890123456789012'
        iv:   '1234567890123456'
        ciphertext:
          'QJyn73i2dlN_V9o2fVLLmh4U85AIEL5v' +
          'Cch2sP5aw3CogMBn5qRpokg6OFjRxsYB' +
          'xb_Oqe8n9GALxJsuuqyZgWXxSK0exA2P' +
          'QnAECIcujG9EyM4GlQodJiJdMtDJh0Dd' +
          'frp7s87w7YWgleaK_3JVqEpjRolj1AWr' +
          'DjXeFDl_tGIZ1R95PD2mbq6OUgm1Q56M' +
          'CRLZdZJOm3yixcGHQOV2wv73YIbOvOa8' +
          'hEZ7ydX-VRHPMmJyFgUe9gv8G8sDm6xY' +
          'UEz1rIu62XwMoMB4B3UZo_r0Q9xCr4sx' +
          'BVPY7bOAp6AUjOuvsHwBGJQHZi3k665w' +
          'mShg7pw8HFkr_Fea4nzimditNTFRhW3K' +
          'MfhqusPDqWJ7K37AvEHDaLULPKBNj24c'
        rsaLength: 342

      'Test vector 2':
        bits: 2048
        data: '1234'
        key:  '12345678901234567890123456789012'
        iv:   '1234567890123456'
        ciphertext:
          'MFq4hhLJN8_F6ODUWX20tO4RIJURlMHA' +
          'mdujFMTyqc2Y3zHIXzmaK4CcoThggqZX' +
          '44-4kbhjwk9ihwuzS4GAQuSCCdoh5xzT' +
          'WfeboPu6zE51BrZQdz67VavvmvpHVdGg' +
          'oQcSsa_GiZcc7aBYh-AhfCyHrPb-r1hN' +
          'y_AWXv8hcO8mIS1fJ3Mvtr3Xxfwlydrn' +
          '23YUwuOG-tX4FctKqh2eFFkrht53ZwVv' +
          '7q67U3x774KjbUpB4LbML6APxe4ucghl' +
          'DpY_A_DFLH2GlvvouVaT3jCibkY_yIMC' +
          '1lNSBIdgpKGoAoZWy4bIpqDUu0SiLvDO' +
          'mclpPRARakRr15F21a_MQ9wL_JNwnG1u' +
          'T1zKZNgUcr2GaWk31ahOBKB0lfr-E7W2'
        rsaLength: 342

      'Test vector 3':
        bits: 2048
        data: '1234567890123456'
        key:  '12345678901234567890123456789012'
        iv:   '1234567890123456'
        ciphertext:
          'oFqfBVNvWyUYThQiA54V_Lpx6Ka2zqEF' +
          'QCQBxcYhnbG2uuShACbf3I31USwRCFDV' +
          'mBLmfcO4ReMJFQzen-tRRuapOQ4Pjzdp' +
          'IRw_T9wYjj0n3Sjs1NZnDbN3hbHCmXoq' +
          'sl0byi0Lr5hwhmqOCj7Po5ey4EsPpuqb' +
          'tPx38PPae-zOlnMrdYuKhV8jIMDSsslf' +
          'VWMOgUlYnDOt9Pd1NEJkJE-GxYIYyzPB' +
          '_NtxwQf5moDjsNzxtx5fzEejo8BGDQ5Q' +
          'phjkQCBmMWd1fKN3Z3aBSNn_WS2HwxzU' +
          'gl10lzaHityP9iZU2DY8qkQB_wSk7-pf' +
          'h05CITq0DPIOHDQzVkcWlnuUZ55SZL-E' +
          'BpxoZDMH74B7GmHK66rSGH0MoSGY1fZC' +
          'hAWyjRKa0nWslBVkLoJRUg'
        rsaLength: 342

      'Test vector 4':
        bits: 4096
        data: '1234567890123456'
        key:  '12345678901234567890123456789012'
        iv:   '1234567890123456'
        ciphertext:
          'rqA8g_yyA0eeLoun6rqnUxgy3JnIS9p8' +
          'bAgZYf4774ZahHcFCOozwWbMU_0HVMS9' +
          'sOlAmr-dQl6RqDaOLfAxrHq3mluFSlXf' +
          'gcJXrvPtf27u_4NCHXuwm825ptpmprPx' +
          'wl0z4tz6u-fqNBSfQuHApZ3MvAGsEa0v' +
          'b0IftBX0q8tKL6sdCx6WpTGcynEdxLcZ' +
          'Tx6cM4LRdcjL3SQZ5vk4VF69lS2r1WgJ' +
          'h8eUa_VwgsqhTkoc7wJAECqxHBQSh6q-' +
          'GOt6bpVnlaGkM_BfcrB5SJdtcEZd5BgG' +
          'xG8QwQGwsT60jErxpd5rYLfBrG7kgVse' +
          'yksfN-99-kUHQpkwCIS_zS5bpr3hLpBi' +
          'UhSA4638Xgd2qyAZCgl3OBY56HSdncZq' +
          '5o4xGycM69eN5hb-c852W-dP6S49BXSn' +
          '3OpmEOkZoIeNw0EYHpLLpfaLwafIVdLC' +
          'bQZX1g_szDcBDyyM-PN5-jnuaqySRywF' +
          'rMj56U9vAvwtFMaHKY-ll4Qxf8PgoDWM' +
          '7KogGgkztlZ0ZzaMwBLQeTDpjbNl5NXJ' +
          'CxobJfGv8w6zQZmDz8J2K3DsQrDmZid_' +
          'W6Gtsv7XsSnY-gl6TD4IkK1VEKnttqXa' +
          'PfVdCNadtQ-Z1INiK2pa3F0NKs4POO-K' +
          'PpW68kQ5l2qeUAVv6B-QdcwunyMh9XO_' +
          'vGx8Wf8SrbZ7lGeeUmS_hAacaGQzB--A' +
          'exphyuuq0hh9DKEhmNX2QoQFso0SmtJ1' +
          'rJQVZC6CUVI'
        rsaLength: 684

    for name, parameters of @specVectorData
      test '- ' + name + ' encryption', =>
        keyName = util.format 'rsa-%s-nopass.private.pem', parameters.bits
        @key = @keyFactory.createPrivateKeyFromFileSync path.resolve @fixturePath, keyName
        (sinon.stub @encryptionCipher, '_generateKey').returns new Buffer parameters.key, 'binary'
        (sinon.stub @encryptionCipher, '_generateIv').returns new Buffer parameters.iv, 'binary'
        expected = parameters.ciphertext.substring parameters.rsaLength
        actual = @encryptionCipher.encrypt @key, parameters.data
        actual = actual.toString 'binary'
        actual = actual.substring parameters.rsaLength

        assert.strictEqual actual, expected

      test '- ' + name + ' decryption', =>
        keyName = util.format 'rsa-%s-nopass.private.pem', parameters.bits
        @key = @keyFactory.createPrivateKeyFromFileSync path.resolve @fixturePath, keyName
        actual = @decryptionCipher.decrypt @key, parameters.ciphertext
        actual = actual.toString 'binary'

        assert.strictEqual actual, parameters.data

  test '- Encrypt/decrypt with generated key', =>
    key = lockbox.keyFactory.generatePrivateKey()
    encrypted = @encryptionCipher.encrypt key, 'foobar'
    decrypted = @decryptionCipher.decrypt key, encrypted

    assert.strictEqual 'foobar', decrypted.toString()

  test '- Generating keys', =>
    key = lockbox.keyFactory.generatePrivateKey()

  test '- Encrypting data', =>
    keyPath = path.resolve @fixturePath, 'rsa-2048.private.pem'
    data = "Super secret data."
    key = lockbox.keyFactory.createPrivateKeyFromFileSync(keyPath, "password")
    encrypted = lockbox.encrypt(key, data)

  test '- Encrypting multiple data', =>
    keyPath = path.resolve @fixturePath, 'rsa-2048.private.pem'
    data = ["Super secret data.", "Extra secret data.", "Mega secret data."]
    key = lockbox.keyFactory.createPrivateKeyFromFileSync(keyPath, "password")
    cipher = new lockbox.BoundEncryptionCipher(key)
    encrypted = []
    i = 0
    while i < data.length
      encrypted.push cipher.encrypt(data[i])
      ++i

  test '- Decrypting data', =>
    keyPath = path.resolve @fixturePath, 'rsa-2048.private.pem'
    encrypted = "<some encrypted data>"
    key = lockbox.keyFactory.createPrivateKeyFromFileSync(keyPath, "password")
    data = undefined
    try
      data = lockbox.decrypt(key, encrypted)
    catch error
      # decryption failed

  test '- Decrypting multiple data', =>
    keyPath = path.resolve @fixturePath, 'rsa-2048.private.pem'
    encrypted = ["<some encrypted data>", "<more encrypted data>", "<other encrypted data>"]
    key = lockbox.keyFactory.createPrivateKeyFromFileSync(keyPath, "password")
    cipher = new lockbox.BoundDecryptionCipher(key)
    decrypted = []
    i = 0
    while i < encrypted.length
      try
        decrypted.push cipher.decrypt(encrypted[i])
      catch error
        # decryption failed
      ++i
