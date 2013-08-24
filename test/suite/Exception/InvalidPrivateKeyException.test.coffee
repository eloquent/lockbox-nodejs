###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

{assert} = require 'chai'
InvalidPrivateKeyException = require '../../../' + process.env.TEST_ROOT + '/Exception/InvalidPrivateKeyException'

suite 'InvalidPrivateKeyException', =>

  test 'With cause', =>
    exception = new InvalidPrivateKeyException 'key', 'foo'

    assert.strictEqual exception.key, 'key'
    assert.strictEqual exception.message, 'The supplied key is not a valid PEM formatted private key.'
    assert.strictEqual exception.toString(), 'The supplied key is not a valid PEM formatted private key.'
    assert.strictEqual exception.cause, 'foo'

  test 'Without cause', =>
    exception = new InvalidPrivateKeyException 'key'

    assert.isNull exception.cause
