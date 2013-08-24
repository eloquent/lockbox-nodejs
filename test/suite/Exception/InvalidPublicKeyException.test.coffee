###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

{assert} = require 'chai'
InvalidPublicKeyException = require '../../../' + process.env.TEST_ROOT + '/Exception/InvalidPublicKeyException'

suite 'InvalidPublicKeyException', =>

  test 'With cause', =>
    exception = new InvalidPublicKeyException 'key', 'foo'

    assert.strictEqual exception.key(), 'key'
    assert.strictEqual exception.message(), 'The supplied key is not a valid PEM formatted public key.'
    assert.strictEqual exception.toString(), 'The supplied key is not a valid PEM formatted public key.'
    assert.strictEqual exception.cause(), 'foo'

  test 'Without cause', =>
    exception = new InvalidPublicKeyException 'key'

    assert.isNull exception.cause()
