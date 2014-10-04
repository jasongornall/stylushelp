wrap = require '../lib/index'

describe 'Less', ->

  it 'should wrap correctly without shortcut', (done) ->
    asset = new wrap.Less {
      src: "#{__dirname}/assets/hello.less"
    }
    asset.on 'error', (err) ->
      throw err
    asset.on 'complete', ->
      asset.md5.should.equal '9568dd9e0d5b126af4fb9f7505b10934'
      done()
    asset.wrap()

  it 'should wrap correctly', (done) ->
    asset = new wrap.Less {
      src: "#{__dirname}/assets/hello.less"
    }, (err) ->
      throw err if err
      asset.md5.should.equal '9568dd9e0d5b126af4fb9f7505b10934'
      done()

  it 'should wrap on callback', (done) ->
    asset = new wrap.Less {
      src: "#{__dirname}/assets/hello.less"
    }, (err) ->
      throw err if err
      asset.md5.should.equal '9568dd9e0d5b126af4fb9f7505b10934'
      done()

  it 'should be able to compress', (done) ->
    asset = new wrap.Less {
      src: "#{__dirname}/assets/hello.less"
      compress: true
    }, (err) ->
      throw err if err
      asset.md5.should.equal '1f1654586705c11ce56755318b715379'
      done()

  it 'should be able to concat', (done) ->
    asset = new wrap.Less {
      src: "#{__dirname}/assets/concat.less"
    }, (err) ->
      throw err if err
      asset.md5.should.equal '2a038c4cf40546c4f232ed8a17348ff5'
      done()

