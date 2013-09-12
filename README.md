# Lockbox for Node.js

*Simple, strong encryption.*

[![Build Status]][Latest build]
[![Test Coverage]][Test coverage report]
[![Uses Semantic Versioning]][SemVer]

## Installation

* Available as [NPM] package [lockbox].

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

## Module exports

### Instances

- **lockbox.keyFactory** - An instance of [lockbox.KeyFactory].

### Functions

- **lockbox.encrypt(key, data)** - Encrypts data using a public key. Throws
  `lockbox.exception.InvalidPublicKeyException` if an invalid key is supplied.
- **lockbox.decrypt(key, data)** - Decrypts data using a private key. Throws
  `lockbox.exception.DecryptionFailedException` on error.

### Classes

#### lockbox.KeyFactory

A factory for creating private and public keys from various sources.

- **createPrivateKey(key, [password])** - Creates a private key from a string.
  Throws `lockbox.exception.InvalidPrivateKeyException` if an invalid key is
  supplied.
- **createPublicKey(key)** - Creates a public key from a string. Throws
  `lockbox.exception.InvalidPublicKeyException` if an invalid key is supplied.
- **createPrivateKeyFromFile(path, [password], callback)** - Creates a private
  key from a file asynchronously. Any errors will be returned as the first
  argument to the callback (see the synchronous version for possible errors).
  Otherwise, the second argument to the callback will be the newly created key.
- **createPrivateKeyFromFileSync(path, [password])** - Creates a private key
  from a file synchronously. Throws `lockbox.exception.ReadException` if the
  file cannot be read. Throws `lockbox.exception.InvalidPrivateKeyException` if
  the file is an invalid key.
- **createPublicKeyFromFile(path, callback)** - Creates a public key from a file
  asynchronously. Any errors will be returned as the first argument to the
  callback (see the synchronous version for possible errors). Otherwise, the
  second argument to the callback will be the newly created key.
- **createPublicKeyFromFileSync(path)** - Creates a public key from a file
  synchronously. Throws `lockbox.exception.ReadException` if the file cannot be
  read. Throws `lockbox.exception.InvalidPublicKeyException` if the file is an
  invalid key.

#### lockbox.EncryptionCipher

A cipher for encrypting data.

- **encrypt(key, data)** - Encrypts data using a public key. Throws
  `lockbox.exception.InvalidPublicKeyException` if an invalid key is supplied.

#### lockbox.DecryptionCipher

A cipher for decrypting data.

- **decrypt(key, data)** - Decrypts data using a private key. Throws
  `lockbox.exception.DecryptionFailedException` on error.

#### lockbox.Cipher

A cipher for encrypting *and* decrypting data.

- **encrypt(key, data)** - Encrypts data using a public key. Throws
  `lockbox.exception.InvalidPublicKeyException` if an invalid key is supplied.
- **decrypt(key, data)** - Decrypts data using a private key. Throws
  `lockbox.exception.DecryptionFailedException` on error.

#### lockbox.BoundEncryptionCipher

A cipher for encrypting data, with a bound key.

- **new lockbox.BoundEncryptionCipher(key)** - Constructs a new bound encryption
  cipher. Throws `lockbox.exception.InvalidPublicKeyException` if an invalid key
  is supplied.
- **encrypt(data)** - Encrypts data using the bound public key.

#### lockbox.BoundDecryptionCipher

A cipher for decrypting data, with a bound key.

- **new lockbox.BoundDecryptionCipher(key)** - Constructs a new bound decryption
  cipher. Throws `lockbox.exception.InvalidPrivateKeyException` if an invalid
  key is supplied.
- **decrypt(data)** - Decrypts data using the bound private key. Throws
  `lockbox.exception.DecryptionFailedException` on error.

#### lockbox.BoundCipher

A cipher for encrypting *and* decrypting data, with a bound key.

- **new lockbox.BoundCipher(key)** - Constructs a new bound cipher. Throws
  `lockbox.exception.InvalidPrivateKeyException` if an invalid key is supplied.
- **encrypt(data)** - Encrypts data using the public key derived from the bound
  private key.
- **decrypt(data)** - Decrypts data using the bound private key. Throws
  `lockbox.exception.DecryptionFailedException` on error.

### Exceptions

- **lockbox.exception.DecryptionFailedException** - Decryption failed.
- **lockbox.exception.InvalidPrivateKeyException** - The supplied key is not a
  valid PEM formatted private key.
- **lockbox.exception.InvalidPublicKeyException** - The supplied key is not a
  valid PEM formatted public key.
- **lockbox.exception.ReadException** - Unable to read from the specified path.

<!-- References -->

[Lockbox website]: http://lqnt.co/lockbox
[lockbox.KeyFactory]: #lockboxkeyfactory
[OpenSSL]: http://en.wikipedia.org/wiki/OpenSSL
[PEM]: http://en.wikipedia.org/wiki/Privacy-enhanced_Electronic_Mail
[RSA]: http://en.wikipedia.org/wiki/RSA_(algorithm)

[Build Status]: https://api.travis-ci.org/eloquent/lockbox-nodejs.png?branch=master
[NPM]: https://npmjs.org/
[lockbox]: https://npmjs.org/package/lockbox
[Latest build]: https://travis-ci.org/eloquent/lockbox-nodejs
[SemVer]: http://semver.org/
[Test coverage report]: https://coveralls.io/r/eloquent/lockbox-nodejs
[Test Coverage]: https://coveralls.io/repos/eloquent/lockbox-nodejs/badge.png?branch=master
[Uses Semantic Versioning]: http://b.repl.ca/v1/semver-yes-brightgreen.png
