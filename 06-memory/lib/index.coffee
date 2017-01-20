fs = require 'fs'
readline = require 'readline'

exports.countryIpCounter = (countryCode, cb) ->
  return cb() unless countryCode

  counter = 0

  # create readable stream of file
  rl = readline.createInterface({
    input : fs.createReadStream(__dirname + '/../data/geo.txt')
  })

  # step through each line, splitting only for matches
  rl.on 'line', (line) ->
    if line.match(RegExp('\\b' + countryCode + '\\b'))
      parts = line.split '\t'
      counter += parts[1] - parts[0]

  # respond with result at EOF
  rl.on 'close', () ->
    cb null, counter
