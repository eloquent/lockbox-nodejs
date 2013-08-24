###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

{assert} = require 'chai'
DecryptionFailedException = require '../../../' + process.env.TEST_ROOT + '/Exception/DecryptionFailedException'

suite 'DecryptionFailedException', =>

  test 'With cause', =>
    exception = new DecryptionFailedException 'foo'

    assert.strictEqual exception.message(), 'Decryption failed.'
    assert.strictEqual exception.toString(), 'Decryption failed.'
    assert.strictEqual exception.cause(), 'foo'

  test 'Without cause', =>
    exception = new DecryptionFailedException

    assert.isNull exception.cause()
