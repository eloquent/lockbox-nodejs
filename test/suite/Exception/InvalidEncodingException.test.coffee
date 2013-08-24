###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

{assert} = require 'chai'
InvalidEncodingException = require '../../../' + process.env.TEST_ROOT + '/Exception/InvalidEncodingException'

suite 'InvalidEncodingException', =>

  test 'With cause', =>
    exception = new InvalidEncodingException 'foo'

    assert.strictEqual exception.message, 'Invalid encoding.'
    assert.strictEqual exception.toString(), 'Invalid encoding.'
    assert.strictEqual exception.cause, 'foo'

  test 'Without cause', =>
    exception = new InvalidEncodingException

    assert.isNull exception.cause
