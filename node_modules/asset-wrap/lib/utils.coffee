Buffer = require('buffer').Buffer
EventEmitter = require('events').EventEmitter

class exports.BufferStream extends EventEmitter
  constructor: (buffer) ->
    @data = new Buffer buffer
    super()
  pipe: (dest) ->
    dest.write @data
    dest.end()
    @emit 'close'
    @emit 'end'
  pause: ->
  resume: ->
  destroy: ->
  readable: true
