###
This file is part of the Lockbox package.

Copyright © 2013 Erin Millard

For the full copyright and license information, please view the LICENSE
file that was distributed with this source code.
###

{assert} = require 'chai'
ReadException = require '../../../' + process.env.TEST_ROOT + '/Exception/ReadException'

suite 'ReadException', =>

  test 'With cause', =>
    exception = new ReadException '/path/to/file', 'foo'

    assert.strictEqual exception.path(), '/path/to/file'
    assert.strictEqual exception.message(), "Unable to read from '/path/to/file'."
    assert.strictEqual exception.toString(), "Unable to read from '/path/to/file'."
    assert.strictEqual exception.cause(), 'foo'

  test 'Without cause', =>
    exception = new ReadException '/path/to/file'

    assert.isNull exception.cause()
