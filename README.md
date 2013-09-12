# Lockbox for Node.js

*Simple, strong encryption.*

[![Build status]][Latest build]
[![Test coverage]][Test coverage report]
[![Uses semantic versioning]][SemVer]

## Installation and documentation

* Available as [NPM] package [lockbox].
* [API documentation] available.

## What is *Lockbox*?

*Lockbox* is the simplest possible way to implement strong, two-way, public-key
encryption for use in applications. *Lockbox* uses a combination of
well-established technologies to ensure the safety of data. For more
information, see the [Lockbox website].

## Usage

### Generating keys via OpenSSL

*Lockbox* uses [RSA] keys in [PEM] format. This is a standard format understood
by [OpenSSL]. Generating of keys is normally handled by the `openssl` command
line tool (although *Lockbox* can also generate keys programmatically).
Generating a 2048-bit private key can be achieved with this command:

    openssl genrsa -out private.pem 2048

Private keys can have password protection. To create a key with a password,
simply add the `-des3` flag, which will prompt for password input before the key
is created:

    openssl genrsa -des3 -out private.pem 2048

This private key must be kept secret, and treated as sensitive data. Private
keys are the only keys capable of decrypting data. Public keys, on the other
hand, are not as sensitive, and can be given to any party that will be
responsible for encrypting data.

*Lockbox* is capable of extracting public keys from private keys, there is no
need to create matching public key files; but if for some reason a public key
file is required, this command will create one:

    openssl rsa -pubout -in private.pem -out public.pem

### Generating keys programmatically

```js
var lockbox = require('lockbox');

var key = lockbox.keyFactory.generatePrivateKey();
```

### Encrypting data

```js
var lockbox = require('lockbox');

var data = 'Super secret data.';

var key = lockbox.keyFactory.createPrivateKeyFromFileSync(
    '/path/to/key.pem',
    'password'
);
var encrypted = lockbox.encrypt(key, data);
```

### Encrypting multiple data packets with the same key

*Lockbox* includes 'bound' ciphers that are locked to a particular key. These
type of ciphers are convenient for encrypting multiple data packets.

```js
var lockbox = require('lockbox');

var data = [
    'Super secret data.',
    'Extra secret data.',
    'Mega secret data.'
];

var key = lockbox.keyFactory.createPrivateKeyFromFileSync(
    '/path/to/key.pem',
    'password'
);
var cipher = new lockbox.BoundEncryptionCipher(key);

var encrypted = [];
for (var i = 0; i < data.length; ++i) {
    encrypted.push(cipher.encrypt(data[i]));
}
```

### Decrypting data

```js
var lockbox = require('lockbox');

var encrypted = '<some encrypted data>';

var key = lockbox.keyFactory.createPrivateKeyFromFileSync(
    '/path/to/key.pem',
    'password'
);

var data;
try {
    data = lockbox.decrypt(key, encrypted);
} catch (error) {
    // decryption failed
}
```

### Decrypting multiple data packets with the same key

*Lockbox* includes 'bound' ciphers that are locked to a particular key. These
type of ciphers are convenient for decrypting multiple data packets.

```js
var lockbox = require('lockbox');

var encrypted = [
    '<some encrypted data>',
    '<more encrypted data>',
    '<other encrypted data>'
];

var key = lockbox.keyFactory.createPrivateKeyFromFileSync(
    '/path/to/key.pem',
    'password'
);
var cipher = new lockbox.BoundDecryptionCipher(key);

var decrypted = [];
for (var i = 0; i < encrypted.length; ++i) {
    try {
        decrypted.push(cipher.decrypt(encrypted[i]));
    } catch (error) {
        // decryption failed
    }
}
```

<!-- References -->

[Lockbox website]: http://lqnt.co/lockbox
[lockbox.KeyFactory]: #lockboxkeyfactory
[OpenSSL]: http://en.wikipedia.org/wiki/OpenSSL
[PEM]: http://en.wikipedia.org/wiki/Privacy-enhanced_Electronic_Mail
[RSA]: http://en.wikipedia.org/wiki/RSA_(algorithm)

[API documentation]: http://lqnt.co/lockbox-nodejs/artifacts/documentation/api/
[Build status]: https://api.travis-ci.org/eloquent/lockbox-nodejs.png?branch=master
[NPM]: https://npmjs.org/
[lockbox]: https://npmjs.org/package/lockbox
[Latest build]: https://travis-ci.org/eloquent/lockbox-nodejs
[SemVer]: http://semver.org/
[Test coverage report]: https://coveralls.io/r/eloquent/lockbox-nodejs
[Test coverage]: https://coveralls.io/repos/eloquent/lockbox-nodejs/badge.png?branch=master
[Uses semantic versioning]: http://b.repl.ca/v1/semver-yes-brightgreen.png
