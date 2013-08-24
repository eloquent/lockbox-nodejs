// Generated by CoffeeScript 1.6.3
/*
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
*/


(function() {
  var EncryptionCipher;

  module.exports = EncryptionCipher = (function() {
    function EncryptionCipher(crypto) {
      if (crypto == null) {
        crypto = require('crypto');
      }
      this._crypto = crypto;
    }

    EncryptionCipher.prototype.encrypt = function(key, data) {
      var digest, encryptedData, encryptedKeyAndIv, generatedKey, hash, iv;
      if (!Buffer.isBuffer(data)) {
        data = new Buffer(data, 'binary');
      }
      generatedKey = this._generateKey();
      iv = this._generateIv();
      encryptedKeyAndIv = key.encrypt(Buffer.concat([generatedKey, iv]));
      hash = this._crypto.createHash('sha1');
      hash.update(data);
      digest = hash.digest();
      encryptedData = this._encryptAes(generatedKey, iv, Buffer.concat([digest, data]));
      return this._base64UriEncode(Buffer.concat([encryptedKeyAndIv, encryptedData]));
    };

    EncryptionCipher.prototype._generateKey = function() {
      return new Buffer(this._crypto.randomBytes(32), 'binary');
    };

    EncryptionCipher.prototype._generateIv = function() {
      return new Buffer(this._crypto.randomBytes(16), 'binary');
    };

    EncryptionCipher.prototype._encryptAes = function(key, iv, data) {
      var cipher;
      cipher = this._crypto.createCipheriv('aes-256-cbc', key, iv);
      return Buffer.concat([cipher.update(data), cipher.final()]);
    };

    EncryptionCipher.prototype._base64UriEncode = function(data) {
      data = data.toString('base64');
      data = data.replace(/\+/g, '-').replace(/\//g, '_').replace(/\=+$/, '');
      return new Buffer(data, 'binary');
    };

    return EncryptionCipher;

  })();

}).call(this);