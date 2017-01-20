through2 = require 'through2'


module.exports = ->
  words = 0
  chars = 0
  lines = 1

  transform = (chunk, encoding, cb) ->
    # before we do anything, update line count
    lines = chunk.split(/\r\n|\r|\n/).length

    # match any character including newline
    chars = chunk.match(/[^]/g).length

    # replace quoted contents with a single word
    # then split camelCase into camel case
    # then match only valid words as specified
    tokens = chunk.replace(/("[^"]*")/g, 'oneword')
                  .replace(/([a-zA-Z])([A-Z])/g, '$1 $2')
                  .match(/[a-zA-Z0-9]+/gm)

    # count your token success
    words = tokens.length

    return cb()

  flush = (cb) ->
    this.push {words, lines}
    this.push null
    return cb()

  return through2.obj transform, flush

# test for quoted, include edge case of nested quotes.
# cheesy method to add a quote as 1 word - replace it with one word
# quoteBecomesWord = chunk.replace(/("([^"]|"")*")/g/, 'oneword')

# camelCase - purely alphaCharacter matched, and considers single letters
# camelCount = chunk.replace(/([a-zA-Z])([A-Z])/g, '$1 $2').split(' ').length

# edge case: wordHa5Numerals
# came1Count = chunk.replace(/([a-z0-9])([A-Z])/g, '$1 $2').split(' ').length
