crypto = require 'crypto'
ursa = require 'ursa'

base64UriDecode = (data) ->
  data = data.replace(/-/g, '+').replace(/_/g, '/')
  data = new Buffer data, 'base64'
  data.toString 'binary'

data = 'wdPXCy5amuY7U8tGD0M-nnK5LGc4DC1h' +
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

pem = '-----BEGIN RSA PRIVATE KEY-----' + "\n" +
'MIIEpAIBAAKCAQEAy8jsljdxzsgvboCytmlH3Q03v30fPTNfMqmz2Yn0GdtkqQH0' + "\n" +
'1+H9y5bWWCQyeGOATvIPrELGeB9nRlQeaTb5VjCl1V9PYeM6Q30PK6411fJexjYA' + "\n" +
'/UbRG/9I/K+A9UBfJvUsjGVUMxZR8n8jmmSy8G2eqXBbP6dEZFnO0V274TRTB3SL' + "\n" +
'KD2tfYBYwMtXqT+rSbH1OyoS29A03FaUgkRk1er2i3ldyNIG8vMGv7Iagup69yBr' + "\n" +
't8xo61IFj76dkocbozp1Y4SGzyjkR/ukRSLe+0ejS4eMyziaH7J52XX1rDFreinZ' + "\n" +
'ZDoE571ameu0biuM6aT8P1pk85VIqHLlqRm/vQIDAQABAoIBAAlqWyQFo8h+D1L3' + "\n" +
't0oeSye3eJ/sVAkr2nYoyRp/+TtIm7oDUSC4XFWPvo+L/Jj7X+5F2NuIqkraiJcD' + "\n" +
'Q/RwicylqsPVB4HqUcLUgGLwRaSA8kgOLrWFFBxLC0BBi5/JPZw7L7e85ssFePvP' + "\n" +
'TAHSLUJWjkId4tlqDQrl61xZDFk3UHawcovZeUp4RAqULeLDXAQTQJYXE8erPjhQ' + "\n" +
'Y0uSWORe1S1ICaI2aqbjmIHFUzPlz45KlakzLwn4tobeiKeNaHrPw++JMXNVSlPk' + "\n" +
'hGxPliXbZauaoDHa/p6w3hDvr2ZjOLU7QDHgdiWZ4EUW5AQRf7aiKtE2yNPTGJQb' + "\n" +
'yv9QHzECgYEA/UQluesABp+UJvvDzbEmDkipgCbEu5fHyGb8C0FPZET1ys2wu0DI' + "\n" +
'IaYR4hiYetrv5inHzXnMSkuQSMzPa+SyBXgiGnB9J2+sBX0H9byq3QuMriTSDQPA' + "\n" +
'ptxZlYAXTEXRUsNYG3/VCiC75VjbufHI7QmsOStTij6w15gchTrBt+cCgYEAzfwL' + "\n" +
'amiGmgVblJ1xr+8zwZMv99c22j8K+Cm4PoUhQ6I6XcgqHyDj8mD65UxQU3aE8R2m' + "\n" +
'vbX7XW1jrpflbVwoRoJS9z8F77rm6t38yS3WJqz6kyoQ0u4W2m8D8g/WWROjeGFD' + "\n" +
'ljrpiwErkmzCGrNhSk4O9YTXrNUGkD5MTpVPBrsCgYBlmdgUnIy3G3+AoBFty/o7' + "\n" +
'UrUE3wifRQV1hLLqBPpHfE6qXBfhFtzyer/D1yAccQY6bFpmOM1WpLeuLNOtMeKk' + "\n" +
'xQvRVX0vu+HjlcQCtfxJjt+R4N2PMQkxJ0ac7fTquTt/GzSWW5LobDdUi3AiSTfU' + "\n" +
't8Oqb5Ik7H9fDfurCuY50wKBgQDDC/wfSVTTeWlLo35oct+WV/JfA7ocFQAlFxQw' + "\n" +
'l011RqNv9D72dOWDuJM7FvUk4yBlVId0MmMQB6oRRCHqWQ6GHZfEKThM1bUdBxD7' + "\n" +
'ytxyiO9I9NczdGHNervItXhppq/vKGKgWa6VgokowLVYJS1l994wXBcBwEHTyjnl' + "\n" +
'W3qWSwKBgQDZo0uMMWevRBriPT6OCdEYwnOZOMvh6LdXG2wyC2wYMY+8XOMzDrZP' + "\n" +
'zD3i4wQYCfJg7pyhVtctBz2NQ8J878xm2EXzUpGaIxjLIXb1UVgw4XXcM7LkjFaa' + "\n" +
'J1iMrMTLGSX89+gW3Bg8hxS7klxZf7ZlVSzLpA2jkK3k5vdgWGVhtA==' + "\n" +
'-----END RSA PRIVATE KEY-----' + "\n";

key = ursa.createPrivateKey pem
# console.log key.getModulus().length

data = base64UriDecode data
keyAndIv = data.substring 0, key.getModulus().length
# console.log keyAndIv.length
keyAndIv = key.decrypt keyAndIv, 'binary', 'binary'
# console.log keyAndIv
generatedKey = keyAndIv.substring 0, 32
iv = keyAndIv.substring 32
# console.log generatedKey, iv

cipher = crypto.createDecipheriv 'aes-256-cbc', generatedKey, iv
decrypted = cipher.update data.substring(key.getModulus().length), 'binary', 'binary'
decrypted += cipher.final 'binary'
# console.log decrypted.length

# decrypted = unpad decrypted

verificationDigest = decrypted.substring 0, 20
decrypted = decrypted.substring 20

hash = crypto.createHash 'sha1'
hash.update decrypted, 'binary'
digest = hash.digest 'binary'

# console.log decrypted, digest is verificationDigest
