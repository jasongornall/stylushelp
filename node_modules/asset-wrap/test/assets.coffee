wrap = require '../lib/index'

describe 'Assets', ->

  it 'should be able to merge assets', (done) ->
    x = 1
    asset1 = new wrap.Stylus {
      src: "#{__dirname}/assets/hello.styl"
    }
    asset2 = new wrap.Stylus {
      src: "#{__dirname}/assets/hello.styl"
    }
    css = new wrap.Assets [
      asset1
      asset2
    ], {
      compress: false
    }, (err) =>
      throw err if err
      asset = css.merge (err) ->
        throw err if err
        done()

