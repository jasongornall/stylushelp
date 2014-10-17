{exec} = require 'child_process'

task 'build', 'Build project from src/*.coffee to lib/*.js', ->
  exec 'coffee --compile --output lib/ src/', (err, stdout, stderr) ->
    throw err if err
    console.log 'Coffee compiled to JS...'
  exec 'cp src/valid_selectors.json lib/valid_selectors.json', (err, stdout, stderr) ->
    throw err if err
    console.log 'Moving json to lib'


