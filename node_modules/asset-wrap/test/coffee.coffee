wrap = require '../lib/index'

describe 'Coffee', ->

  it 'should wrap correctly without shortcut', (done) ->
    asset = new wrap.Coffee {
      src: "#{__dirname}/assets/hello.coffee"
    }
    asset.on 'error', (err) ->
      throw err
    asset.on 'complete', ->
      asset.md5.should.equal 'b01b34326cd38ea077632ab9b98a911a'
      done()
    asset.wrap()

  it 'should wrap correctly', (done) ->
    asset = new wrap.Coffee {
      src: "#{__dirname}/assets/hello.coffee"
    }, (err) ->
      throw err if err
      asset.md5.should.equal 'b01b34326cd38ea077632ab9b98a911a'
      done()

  it 'should wrap on callback', (done) ->
    asset = new wrap.Coffee {
      src: "#{__dirname}/assets/hello.coffee"
    }, (err) ->
      throw err if err
      asset.md5.should.equal 'b01b34326cd38ea077632ab9b98a911a'
      done()

  it 'should be able to compress', (done) ->
    asset = new wrap.Coffee {
      src: "#{__dirname}/assets/hello.coffee"
      compress: true
    }, (err) ->
      throw err if err
      asset.md5.should.equal '323da5a76efc1215d09491ba7d40129c'
      done()

