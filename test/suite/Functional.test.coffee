###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

{assert} = require 'chai'
path = require 'path'
sinon = require 'sinon'
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
        data: ''
        key:  '12345678901234567890123456789012'
        iv:   '1234567890123456'
        ciphertext:
          'FzFcxXm57XqDzsZm4vVUaspsK1-Hcw7fN' +
          'jAqadl-WhwR_Kfwv4gM7v7OnDGWfpDOTl' +
          'I_nlQvvwP3TP98tOhyrsJkpDDMZ0WSQVP' +
          'cl23xTk6xbLvwl2qRVdZa8isKCXXcuKt5' +
          'XIv1Mexp2Dzyn8w8TNYOdK0EiNj1v2PUk' +
          '7X2QUPvK0poT_3fUlN13aK28KBqg-CGw0' +
          'xzsGSG4k7CN8FEfGqbSBfuNxumH0eJyzZ' +
          '1s4cYbcn3OWdlQln7asp21WZHj7SEMWIf' +
          'dsrtoWL85uEAnLxYG_CXD1nteVXffAwFv' +
          'ByMT1UmNQ0AWjm8KJiH8hLXPr09rbo5Vz' +
          's6c5lSrjMmM9itNTFRhW3KMfhqusPDqWJ' +
          '7K37AvEHDaLULPKBNj24c'

      'Test vector 2':
        data: '1234'
        key:  '12345678901234567890123456789012'
        iv:   '1234567890123456'
        ciphertext:
          'wdPXCy5amuY7U8tGD0M-nnK5LGc4DC1h' +
          'VwvNWVLCyqOMHgDF3fpsY-8MQkMUuI0T' +
          'eNoutU-TpuGsm6D-KIXeAaWIYuUAaNZ-' +
          'V_5WwmRFT5BEyhQwZ3PFybrs39o4sAlO' +
          'd5IVvLNMMgwRD-FmQc8KU10d3KDd71wW' +
          'r50y7R33xTnyJplx9uqcOrB6ooQLjFcF' +
          'bFU87YPnhkxZK5JryTxAlaDJjfFs-3XM' +
          'zgoJ35rpBgDVywPXbye1C8u5gw81awid' +
          'Xgei_a27MZog1lUvETzMXqqZ4VlhckDV' +
          'm71f4TLMKHTz-CmYinvzj7G_pYmvtHeh' +
          'uxDzjdrT4lbetTuESm-YHKtq9JEj6E2S' +
          'ER4TURlVKf14sPeDgRUo88-zvM7BWpMv'

      'Test vector 3':
        data: '1234567890123456'
        key:  '12345678901234567890123456789012'
        iv:   '1234567890123456'
        ciphertext:
          'umvbDKEQtKldCN15bgyGyLm5K5LEDNGJ' +
          'kXbyYask_sgSi9lkGa5ByDZKVs1SMgp0' +
          'mif4GDfyg5xVadsPzoH9-jdSoTB7pNxz' +
          'ns8CNP8KIWEcU6TATwjbW9bP5FBQKxRO' +
          'OTHdLLJ7ADqvuT0QxH1Yy1xzlVGXUXxk' +
          'coMBey_CxiboqjLm_cEl1dA0HyidgxTn' +
          'rArsM7porZPj__gbWIEv58L0S2xv11YL' +
          '0IQMGkQiupJhHKiyAIH4KchZ8whV_aAZ' +
          '193U7toEJ7Ojd7uu6hzMiVDCIRPDa5Ek' +
          'zyBFoNsr2hcTFcU4oxBkRbUottvH9Dji' +
          'SxIPU4O8vomXpUqWzneJ4CBlVmSYgUJa' +
          '4zsJUnll4lufFRTYTYjuCgQhunOAIVS2' +
          'DxuQH8bSZZrHKNIghc0D3Q'

    for name, parameters of @specVectorData
      test '- ' + name + ' encryption', =>
        (sinon.stub @encryptionCipher, '_generateKey').returns new Buffer parameters.key, 'binary'
        (sinon.stub @encryptionCipher, '_generateIv').returns new Buffer parameters.iv, 'binary'
        expected = parameters.ciphertext.substring 342
        actual = @encryptionCipher.encrypt @key, parameters.data
        actual = actual.toString 'binary'
        actual = actual.substring 342

        assert.strictEqual actual, expected

      test '- ' + name + ' decryption', =>
        actual = @decryptionCipher.decrypt @key, parameters.ciphertext
        actual = actual.toString 'binary'

        assert.strictEqual actual, parameters.data

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
