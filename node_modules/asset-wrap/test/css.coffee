wrap = require '../lib/index'

describe 'CSS', ->

  it 'should wrap correctly without shortcut', (done) ->
    asset = new wrap.CSS {
      src: "#{__dirname}/assets/hello.css"
    }
    asset.on 'error', (err) ->
      throw err
    asset.on 'complete', ->
      asset.md5.should.equal '1c2300e780af0bf95dcd7b5afc9e6453'
      done()
    asset.wrap()

  it 'should wrap correctly', (done) ->
    asset = new wrap.CSS {
      src: "#{__dirname}/assets/hello.css"
    }, (err) ->
      throw err if err
      asset.md5.should.equal '1c2300e780af0bf95dcd7b5afc9e6453'
      done()

  it 'should minify correctly', (done) ->
    asset = new wrap.CSS {
      src: "#{__dirname}/assets/hello.css"
      minify: true
    }, (err) ->
      throw err if err
      asset.md5.should.equal 'f5574ce2f208cbd2827ee32f4dbe349a'
      done()

